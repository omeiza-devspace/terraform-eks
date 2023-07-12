locals {
  global_cidr = "0.0.0.0"
}

# create route table and add public route
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = local.global_cidr
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.env}-public-route"
  }
}

# associate all public subnets to the public route table
resource "aws_route_table_association" "public_subnets_assoc_az1" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


# create route table and add public route
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = local.global_cidr
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "${var.env}-private-route"
  }
}


# associate all private subnets to the private route table
resource "aws_route_table_association" "private_subnets_assoc_az1" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

