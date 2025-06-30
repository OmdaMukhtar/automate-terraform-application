resource "aws_instance" "web" {
  instance_type = "t3.micro"
  ami = data.aws_ami.this.id
  user_data       = filebase64("scripts/user_data.sh")
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  subnet_id = aws_subnet.mainsubnet.id
  associate_public_ip_address = true
  
  depends_on = [aws_internet_gateway.igw]

#   key_name = "kali"

  tags = {
    Name = "webserver"
  }
}

resource "aws_vpc" "this" {
  cidr_block = "172.31.0.0/16"
  enable_dns_support   = true   
  enable_dns_hostnames = true

  tags = {
    Name = "project-x-vpc"
  }
}

resource "aws_subnet" "mainsubnet" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "172.31.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Main-Subnet"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.this.id    

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "associate" {
  subnet_id      = aws_subnet.mainsubnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route" "route" {
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "allow http"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "allow ssh"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow outbound"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allowSG"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

data "aws_ami" "this" {
  owners =["amazon"]
  most_recent = true

  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  filter {
    name ="name"
    values = ["al2023-ami-2023*"]
  }
}