/*
  Cria a VPC
*/
resource "aws_vpc" "test_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true #Fornece um nome de domínio interno
  enable_dns_hostnames = true #Fornece um nome de host interno

  tags = {
    name = "test-vpc"
  }
}

/*
  Cria o Gateway de Internet
*/
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "vpc-igw"
  }
}

/*
  Cria uma subnet pública
*/
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = "true" // Torna esta uma sub-rede pública

  tags = {
    Name = "vpc-public_subnet"
  }
}

/*
  Cria uma tabela personalizada de rotas
*/
resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    //A sub-rede associada pode chegar a qualquer lugar
    cidr_block = "0.0.0.0/0"

    //CRT usa este IGW para alcançar a internet
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "vpc-public_crt"
  }
}

/*
  Associa a CRT à subnet.
*/
resource "aws_route_table_association" "public_crt_subnet"{
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_crt.id
}

// Envia chave pública para o recurso
resource "aws_key_pair" "webserver-key-pair" {
  key_name = "virginia-key-pair"
  public_key = "${file(var.public_key_path)}"
}

/*
  Cria a instância EC2
*/
resource "aws_instance" "webserver" {
  ami = var.ami.virginia
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id]
  key_name = aws_key_pair.webserver-key-pair.id

  # Envia o script de instalação do NGINX
  provisioner "file" {
    source = "nginx.sh"
    destination = "/tmp/nginx.sh"
  }

  # Executa a instalação remota do NGINX
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/nginx.sh",
      "sudo /tmp/nginx.sh"
    ]
  }

  connection {
    type = "ssh"
    user = var.ec2_user
    private_key = "${file(var.private_key_path)}"
    host = self.public_ip
  }
}
