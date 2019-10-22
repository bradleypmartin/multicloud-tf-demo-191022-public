//////////////////////////////////////
// AWS EC2 webserver security group //
//////////////////////////////////////

// For our EC2 webserver SG we'll want to allow HTTP access from anywhere
// and SSH access from my house (I'll remove this hardcoding soon ;) )
resource "aws_security_group" "allow-http-ssh" {
  name        = "allow_http_and_ssh"
  description = "Allow HTTP inbound traffic from anywhere; SSH from my home"
  vpc_id      = "${aws_vpc.multicloud-test-vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["<your development IPv4 address>/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
