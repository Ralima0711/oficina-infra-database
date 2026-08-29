output "vpc_id" {
  description = "VPC onde o RDS foi criado"
  value       = data.aws_vpc.selected.id
}

output "vpc_cidr_block" {
  description = "CIDR da VPC (útil para SGs da Lambda e do EKS)"
  value       = data.aws_vpc.selected.cidr_block
}

output "subnet_ids" {
  description = "Subnets usadas pelo RDS"
  value       = var.subnet_ids
}

output "rds_security_group_id" {
  description = "Security group do PostgreSQL"
  value       = aws_security_group.rds_sg.id
}

output "db_endpoint" {
  description = "Endpoint host:porta"
  value       = aws_db_instance.oficina_db.endpoint
  sensitive   = true
}

output "db_address" {
  description = "Hostname do RDS"
  value       = aws_db_instance.oficina_db.address
  sensitive   = true
}

output "db_port" {
  description = "Porta do PostgreSQL"
  value       = aws_db_instance.oficina_db.port
}

output "db_name" {
  description = "Nome do banco"
  value       = aws_db_instance.oficina_db.db_name
}

output "db_username" {
  description = "Usuário administrador"
  value       = var.db_username
  sensitive   = true
}
