resource "aws_subnet" "private" {
  count = lenght(var.private_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    { Name = "${var.env}-private-${azs[count.index]}" },
    var.private_subnet_tags
  )
}

resource "aws_subnet" "public" {
  count = lenght(var.public_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    { Name = "${var.env}-public-${azs[count.index]}" },
    var.public_subnet_tags
  )
}