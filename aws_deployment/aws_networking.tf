//////////////////////////////
// AWS EC2 networking setup //
//////////////////////////////

// networking with custom VPC
resource "aws_vpc" "multicloud-test-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "multicloud-test-vpc"
  }
}

// custom subnet and route table stuff
resource "aws_subnet" "mc-test-subnet" {
  cidr_block        = "${cidrsubnet(aws_vpc.multicloud-test-vpc.cidr_block, 3, 1)}"
  vpc_id            = "${aws_vpc.multicloud-test-vpc.id}"
  availability_zone = "us-east-1a"
}

resource "aws_route_table" "route-table-test-env" {
  vpc_id = "${aws_vpc.multicloud-test-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test-env-igw.id}"
  }
  tags = {
    Name = "multicloud-test-env-route-table"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.mc-test-subnet.id}"
  route_table_id = "${aws_route_table.route-table-test-env.id}"
}

// Internet Gateway for opening custom subnet to the world (for HTTP/SSH)
resource "aws_internet_gateway" "test-env-igw" {
  vpc_id = "${aws_vpc.multicloud-test-vpc.id}"
  tags = {
    Name = "multicloud-test-igw"
  }
}
