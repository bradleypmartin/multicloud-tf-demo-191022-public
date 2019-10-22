// thanks to https://medium.com/@hmalgewatta/ for the help with AWS setup!

/////////////////////////////////////
// AWS EC2 webserver compute setup //
/////////////////////////////////////

// Elastic IP for consistent access via HTTP - attaching to EC2 instance below
resource "aws_eip" "ip-mc-test" {
  instance = "${aws_instance.multicloud-ec2-instance.id}"
  vpc      = true
}

// Thanks to A Cloud Guru (acloud.guru) for the simple HTTP bootstrap script
locals {
  instance-userdata = <<EOF
#!/bin/bash
yum update -y
yum install httpd -y
echo "<html><body><center><h1>Hello to the Tuesday Tech Talk audience...from AWS!</h1></center></body></html>" > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
EOF
}

resource "aws_instance" "multicloud-ec2-instance" {
  // Launching instance with Amazon Linux 2 AMI and bootstrap script above
  ami           = "ami-0b69ea66ff7391e80"
  instance_type = "t2.micro"
  user_data_base64 = "${base64encode(local.instance-userdata)}"

  key_name = "multicloud-key-pair"

  security_groups = ["${aws_security_group.allow-http-ssh.id}"]
  subnet_id       = "${aws_subnet.mc-test-subnet.id}"

  tags = {
    Name = "ExampleHttpServer"
  }
}
