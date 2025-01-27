import { ECSClient, ListTasksCommand, ExecuteCommandCommand } from "@aws-sdk/client-ecs";
import { TextDecoder } from "util";
import ssm from "./ssm.mjs";

const ecsClient = new ECSClient({});
const textDecoder = new TextDecoder();

const { CLUSTER_NAME, SERVICE_NAME, CONTAINER_NAME, COMMAND, TIMEOUT, FAIL_ON_ERROR } = process.env;

const exitCodeRegex = /SEED-EXIT-CODE\((\d+)\)/;
const command = `bash -c 'timeout ${TIMEOUT} ${COMMAND}; echo "SEED-EXIT-CODE($?)"'`;
const termOptions = {
  cols: 300,
  rows: 100,
};
const payloadTypes = {
  output: 1,
  reinitialize: 17,
};

async function retry(fn, retries = 5, delay = 500) {
  for (let i = 0; i < retries; i++) {
    try {
      return await fn();
    } catch (error) {
      console.error(`Attempt ${i + 1} failed: ${error.message}`);
      if (i < retries - 1) {
        const waitTime = delay * Math.pow(2, i);
        console.log(`Waiting ${waitTime}ms before another try`);
        await new Promise(resolve => setTimeout(resolve, waitTime));
      } else {
        throw error;
      }
    }
  }
}

async function getTaskArn() {
  const listTasksCommand = new ListTasksCommand({
    cluster: CLUSTER_NAME,
    serviceName: SERVICE_NAME,
    desiredStatus: 'RUNNING'
  });

  const listTasksResult = await ecsClient.send(listTasksCommand);
  if (!listTasksResult.taskArns || listTasksResult.taskArns.length === 0) {
    throw new Error('No running tasks found in backend service');
  }

  return listTasksResult.taskArns[0];
}

async function executeCommand(taskArn, command) {
  const executeCommandCommand = new ExecuteCommandCommand({
    cluster: CLUSTER_NAME,
    task: taskArn,
    container: CONTAINER_NAME,
    command: command,
    interactive: true
  });

  const executeCommandResult = await ecsClient.send(executeCommandCommand);

  return executeCommandResult.session;
}

async function getCommandOutput(streamUrl, tokenValue) {
  const connection = new WebSocket(streamUrl);
  connection.binaryType = "arraybuffer";

  let exitCode = 1;

  return new Promise((resolve, reject) => {
    connection.onopen = () => {
      ssm.init(connection, {
        token: tokenValue,
        termOptions: termOptions,
      });

      console.log("Connection to backend task established");
    };

    connection.onerror = (error) => {
      console.error(`Connection to backend task error: ${error}`);
      reject(error);
    };

    connection.onmessage = (event) => {
      var agentMessage = ssm.decode(event.data);
      ssm.sendACK(connection, agentMessage);

      if (agentMessage.payloadType === payloadTypes.output) {
        const message = textDecoder.decode(agentMessage.payload);
        console.log(message);

        const match = message.match(exitCodeRegex);
        if (match) {
          exitCode = parseInt(match[1]);
          if (isNaN(exitCode)) {
            console.error("Failed to parse seed command exit code");
            exitCode = 1;
          }

          console.log("Found end of seed command output, closing connection to backend task");
          connection.close();
        }
      } else if (agentMessage.payloadType === payloadTypes.reinitialize) {
        ssm.sendInitMessage(connection, termOptions);
      }
    };

    connection.onclose = () => {
      console.log("Connection to backend task closed");
      resolve(exitCode);
    };
  });
}

export const handler = async () => {
  const taskArn = await retry(() => getTaskArn());
  console.log(`Executing seed command on backend task ${taskArn}`);

  const { streamUrl, tokenValue } = await retry(() => executeCommand(taskArn, command));

  const exitCode = await getCommandOutput(streamUrl, tokenValue);
  const exitMessage = `Seed command exit code: ${exitCode}`;
  if (FAIL_ON_ERROR === 'true' && exitCode !== 0) {
    console.error(exitMessage);
    throw new Error(exitMessage);
  }

  console.log(exitMessage);

  return {
    statusCode: exitCode === 0 ? 200 : 500,
    body: JSON.stringify({
      message: exitMessage,
      exitCode: exitCode,
    })
  };
};
