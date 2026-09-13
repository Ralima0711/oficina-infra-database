# Interface endpoint do SSM: a Lambda na VPC alcança
# /oficina/auth/jwt-private-key sem NAT e sem JwtPrivateKeyB64.
# Ingress 443 na CIDR da VPC (mesmo criterio do SG do RDS).

resource "aws_security_group" "vpce_ssm" {
  name        = "${var.project_name}-vpce-ssm-sg"
  description = "HTTPS 443 para o VPC endpoint do SSM"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "HTTPS a partir da VPC (Lambda)"
    from_port   = 443
    to_port     = 443
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

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = data.aws_vpc.selected.id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.vpce_ssm.id]
  private_dns_enabled = true

  tags = {
    Project = "oficina-mecanica"
    Stack   = "database"
    Name    = "${var.project_name}-ssm"
  }
}
