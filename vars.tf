/*
 Todas as variáveis estarão neste arquivo.
*/

/*
  Definindo os valores para região.
*/
variable "region" {
  description = "Região padrão para VPC"
  #-----> Configure aqui sua região de preferência <---------------|
  default = "us-east-1"
}

/*
  Definindo o tipo de Instância.
*/
variable "instance_type" {
  default = "t2.micro"
}

/*
  Definindo os valores para subnet Principal.
*/
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

/*
  Definindo os valores para subnet Publica.
*/
variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

/*
  Definindo a imagem EC2 para uso.
*/
variable "ami" {
  type = map

  default = {
    virginia: "ami-0b0ea68c435eb488d"
  }
}

/*
  Definindo a chave publica para região.
*/
variable "public_key_path" {
  default = "./key-pairs/key-pair.pub"
}

/*
  Definindo a chave privada para região.
*/
variable "private_key_path" {
  default = "./key-pairs/key-pair.pem"
}

/*
  Definindo o usuário de acesso ao EC2.
*/
variable "ec2_user" {
  default = "ubuntu"
}