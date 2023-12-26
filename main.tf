provider "aws" {
  region     = "us-east-1"
}

resource "aws_instance" "foo" {
  ami                    = "ami-05fb0b8c1424f266b"
  instance_type          = "t2.micro"

  tags = {
    Name = "tf_instance"
  }

}
