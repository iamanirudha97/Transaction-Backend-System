resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default_e1" {
  availability_zone = "us-east-1a"

  tags = {
    Name = "Default subnet for us-east-1a"
  }
}

resource "aws_default_subnet" "default_e2" {
  availability_zone = "us-east-1b"
}


resource "aws_db_subnet_group" "default_subnet_group" {
  name = "default-vpc-rds-subnet-group"

  subnet_ids = [
    aws_default_subnet.default_e1.id,
    aws_default_subnet.default_e2.id
  ]
}
