resource "aws_key_pair" "this" {
  key_name   = "${var.env}-key-pair"
  public_key = file(var.ssh_key_pair)
}
