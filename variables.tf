variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefixo dos recursos do banco"
  type        = string
  default     = "oficina-mecanica"
}

variable "subnet_ids" {
  description = "Subnets da VPC do laboratório (mínimo 2 AZs para o RDS)"
  type        = list(string)
}

variable "db_username" {
  description = "Usuário administrador do PostgreSQL"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Senha do PostgreSQL"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Classe da instância RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Armazenamento em GB"
  type        = number
  default     = 20
}
