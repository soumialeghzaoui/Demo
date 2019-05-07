#configure the provider 

provider "aws"{
}

#create vpc resource
resource "aws_vpc" "mysite" {
    cidr_block = "172.23.0.0/16"
}

#create private subnet resource
resource "aws_subnet" "private" {
    vpc_id = "${aws_vpc.mysite.id}"
    cidr_block = "172.23.1.0/24"
}

#create public subnet resource
resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.mysite.id}"
    cidr_block = "172.23.10.0/24"
}
#create internet gateway resource 
resource "aws_internet_gateway" "IGW" {
    vpc_id = "${aws_vpc.mysite.id}"
    
}

#create route table resource 
resource "aws_route_table" "RT"{
    vpc_id = "${aws_vpc.mysite.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.IGW.id}"    
    }
}

#create route table association
resource "aws_route_table_association" "RTA" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.RT.id}"
}

terraform {
backend "s3" {
bucket="backedterraform"
key="TP/VPC/terraform.tfstate"
region="us-east-1"
}
}