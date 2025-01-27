data "aws_availability_zones" "available" {}

locals {
  prefix         = "${var.context.project}-${var.context.environment}-vpc"
  public_prefix  = "${local.prefix}-public"
  private_prefix = "${local.prefix}-private"
  tags = {
    Component = "VPC"
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = merge(local.tags, { Name = local.prefix })
}

resource "aws_subnet" "public" {
  count = var.az_count

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(local.tags, { Name = local.public_prefix })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, { Name = "${local.public_prefix}-igw" })
}

resource "aws_eip" "main" {
  count = var.az_count

  tags = merge(local.tags, { Name = "${local.public_prefix}-ngw" })
}

resource "aws_nat_gateway" "main" {
  count      = var.az_count
  depends_on = [aws_internet_gateway.main]

  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.main[count.index].id

  tags = merge(local.tags, { Name = "${local.public_prefix}-ngw" })
}

resource "aws_route_table" "public" {
  count = var.az_count

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.tags, { Name = local.public_prefix })
}

resource "aws_route_table_association" "public" {
  count = var.az_count

  route_table_id = aws_route_table.public[count.index].id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_subnet" "private" {
  count = var.az_count

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(local.tags, { Name = local.private_prefix })
}

resource "aws_route_table" "private" {
  count = var.az_count

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = merge(local.tags, { Name = local.private_prefix })
}

resource "aws_route_table_association" "private" {
  count = var.az_count

  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = aws_subnet.private[count.index].id
}
