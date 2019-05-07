resource "aws_security_group" "AllowTraffic" {
    name = "allow_htttp"
    vpc_id = "${aws_vpc.mysite.id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "http"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
  
}

#create an ec2 instance resource 
data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
} 

#create user_data for the ec2 instance

data "template_file" "user_data" {
    template = "user_data.php"
}

resource "aws_instance" "web" {
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "t2.micro"
    user_data = "${data.template_file.user_data.rendered}"
    security_groups =[ "${aws_security_group.AllowTraffic.id}" ]
    subnet_id = "${aws_subnet.public.id}"
} 

