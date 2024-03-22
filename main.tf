provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "Review" {
    name = "Review"
    ingress {
        description = "http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Jenkins"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "All Traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "All Traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "Amazon_Linux2" {
    instance_type = "t2.medium"
    ami = "ami-02d7fd1c2af6eead0"
    key_name = "GenPair"
    tags = {
        Name = "Amazon_Linux2"
    }

    user_data = <<-EOF
        #!/bin/bash
        sudo yum update -y
        sudo yum install httpd firewalld -y
        sudo systemctl start httpd
        sudo systemctl enable httpd
        sudo systemctl start firewalld 
        sudo systemctl enable firewalld
        sudo firewall-cmd --permanent --add-service=http
        sudo firewall-cmd --reload
        echo "This is for hostname $(hostname -f)" >> /var/www/html/index.html
    EOF

    vpc_security_group_ids = [aws_security_group.Review.id]
}
