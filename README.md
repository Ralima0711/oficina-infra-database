# oficina-infra-database

Infraestrutura como código do **banco de dados gerenciado (AWS RDS PostgreSQL 15)** do Tech Challenge SOAT — Fase 3 (Grupo 32).

> Repositório 3 de 4 da Fase 3. Ver também: [oficina-mecanica-api](https://github.com/Ralima0711/oficina-mecanica-api) · [oficina-lambda-auth](https://github.com/Ralima0711/oficina-lambda-auth) · [oficina-infra-k8s](https://github.com/Ralima0711/oficina-infra-k8s)

## Propósito

Provisionar o banco relacional gerenciado usado tanto pela aplicação quanto pela Lambda de autenticação. Isolado da infraestrutura de cluster (repo `oficina-infra-k8s`) para permitir ciclo de vida e CI/CD independentes.

## Por que PostgreSQL gerenciado

PostgreSQL 15 foi escolhido pela robustez em consultas complexas, suporte a tipos avançados (JSONB, arrays), conformidade com o padrão SQL e integração nativa com o Eloquent ORM. O uso do RDS gerenciado entrega backups automáticos, alta disponibilidade e patching sem operação manual.

## Tecnologias

| Tecnologia | Papel |
|---|---|
| Terraform (≥ 1.3) | Provisionamento da infraestrutura AWS |
| AWS RDS PostgreSQL 15 | Banco de dados gerenciado |
| AWS VPC / Security Groups | Rede privada e restrição de acesso (porta 5432) |
| GitHub Actions | Pipeline CI/CD (`terraform plan` → `apply`) |

## Recursos provisionados

| Recurso | Detalhe |
|---|---|
| `aws_db_instance` | PostgreSQL 15, db.t3.micro, 20 GB, subnets privadas |
| `aws_db_subnet_group` | Grupo de subnets privadas |
| `aws_security_group` | Acesso à porta 5432 restrito à VPC |

## Execução / Deploy

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

O deploy é automatizado via GitHub Actions nas branches `homolog` e `main`.

## Modelo de dados

Diagrama ER e justificativa do modelo relacional: ver documentação de arquitetura da Fase 3 (entregável da Tech Lead).

## Regras de contribuição

Branch `main` protegida. Todo merge via **Pull Request** com aprovação de outro membro. Nunca commitar `terraform.tfvars`, senhas ou state com segredos.

## Time — Grupo 32

Roberta Lima (Tech Lead) · Gustavo Delfino (Infra/CI-CD) · David Tavares (Infra/CI-CD) · Johny David (Aplicação)
