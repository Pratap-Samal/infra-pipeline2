
resource "aws_key_pair" "deployer" {
  key_name   = "pratap-key"
  public_key = file("${path.module}/pratap-key.pub")

  
}