/*
  Cria o Grupo de Segurança para permitir acesso SSH
*/
resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id = aws_vpc.test_vpc.id

  //Libera acesso SSH pela porta 22.
  ingress {
    description = "SSH from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"

    // Não faça isso em produção.
    // Isso significa que todos os endereços IP têm permissão para acesso ssh!
    // Informe aqui seu endereço de rede.
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_allow_ssh"
  }
}

/*
  Cria o Grupo de Segurança para permitir acesso HTTP
*/
resource "aws_security_group" "allow_http" {
  vpc_id = aws_vpc.test_vpc.id

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  //Libera acesso HTTP pela porta 80.
  ingress {
    description = "HTTP from VPC"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg_allow_http"
  }
}