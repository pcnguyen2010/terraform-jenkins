provider "aws" {
  region     = "us-east-2"
  access_key = "AKIAQPNNHBFIY77NU3U7"
  secret_key = "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"
}

resource "aws_instance" "foo" {
  ami                    = "ami-05fb0b8c1424f266b"
  instance_type          = "t2.micro"

  tags = {
    Name = "tf_instance"
  }

}
