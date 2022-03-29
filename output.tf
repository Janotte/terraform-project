output "vpc" {
  value = [
    aws_vpc.test_vpc.tags.name,
    aws_vpc.test_vpc.cidr_block
  ]
}

output "webserver" {
  value = [
    aws_instance.webserver.ami,
    aws_instance.webserver.instance_type,
    aws_instance.webserver.subnet_id,
    aws_instance.webserver.public_ip,
    aws_instance.webserver.public_dns
  ]
}