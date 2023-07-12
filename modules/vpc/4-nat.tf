# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet az1 
resource "aws_eip" "this" {
  vpc = true

  tags = {
    Name = "${var.env}-eip"
  }
}


resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.this]

  tags = {
    Name = "${var.env}-nat"
  }
}