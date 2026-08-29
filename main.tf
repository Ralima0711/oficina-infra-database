data "aws_subnet" "selected" {
  id = var.subnet_ids[0]
}

data "aws_vpc" "selected" {
  id = data.aws_subnet.selected.vpc_id
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-db-sg"
  description = "PostgreSQL 5432 restrito a CIDR da VPC"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "PostgreSQL a partir da VPC (EKS e Lambda)"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = "oficina-mecanica"
    Stack   = "database"
  }
}

resource "aws_db_subnet_group" "oficina" {
  name       = "${var.project_name}-db-subnet"
  subnet_ids = var.subnet_ids

  tags = {
    Project = "oficina-mecanica"
    Stack   = "database"
  }
}

resource "aws_db_instance" "oficina_db" {
  identifier          = "${var.project_name}-db"
  engine              = "postgres"
  engine_version      = "15"
  instance_class      = var.db_instance_class
  allocated_storage   = var.db_allocated_storage
  storage_encrypted   = true
  multi_az            = false
  publicly_accessible = false
  skip_final_snapshot = true
  apply_immediately   = true

  db_name  = "oficina_mecanica"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.oficina.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Project = "oficina-mecanica"
    Stack   = "database"
  }
}
