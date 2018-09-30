resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "rails_seed"
  }
}

resource "aws_subnet" "default" {
  vpc_id            = "${aws_vpc.default.id}"
  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.0.0/24"

  tags {
    Name = "rails_seed"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "rails_seed"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "rails_seed"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.default.id}"
  route_table_id = "${aws_route_table.r.id}"
}

resource "aws_security_group" "public_ssh_connection" {
  name        = "public_ssh_connection"
  description = "enable connection from public via ssh."
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "full_open_outbound" {
  name        = "full_open_outbound"
  description = "enable connection for full-open."
  vpc_id      = "${aws_vpc.default.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "rails_seed" {
  ami           = "ami-06cd52961ce9f0d85"
  instance_type = "t2.small"
  ebs_optimized = false
  monitoring    = false
  key_name      = "rails_seed"

  vpc_security_group_ids = [
    "${aws_security_group.public_ssh_connection.id}",
    "${aws_security_group.full_open_outbound.id}",
  ]

  subnet_id = "${aws_subnet.default.id}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  tags {
    Group = "rails_seed"
    Name  = "rails_seed"
  }
}

resource "aws_eip" "default" {
  vpc = true

  tags {
    Name = "rails_seed"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.rails_seed.id}"
  allocation_id = "${aws_eip.default.id}"
}
