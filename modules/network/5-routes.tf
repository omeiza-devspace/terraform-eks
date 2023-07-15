locals {
  global_cidr = "0.0.0.0/0"
}
 
# create route table and add private route
resource "aws_route_table" "private_route" {
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
resource "aws_route_table_association" "private_subnets_az_assocociations" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_route.id
}

# create route table and add public route
resource "aws_route_table" "public_route" {
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
resource "aws_route_table_association" "public_subnets_az_associations" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route.id
}


