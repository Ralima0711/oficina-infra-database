# oficina-infra-database

Infraestrutura como código do **banco de dados gerenciado (AWS RDS PostgreSQL 15)** do Tech Challenge SOAT — Fase 3 (Grupo 183).

> Repositório 3 de 4 da Fase 3. Ver também: [oficina-mecanica-api](https://github.com/Ralima0711/oficina-mecanica-api) · [oficina-lambda-auth](https://github.com/Ralima0711/oficina-lambda-auth) · [oficina-infra-k8s](https://github.com/Ralima0711/oficina-infra-k8s)

## Propósito

Provisionar o banco relacional gerenciado usado tanto pela aplicação (EKS) quanto pela Lambda de autenticação. Isolado da infraestrutura de cluster (repo `oficina-infra-k8s`) para permitir ciclo de vida e CI/CD independentes.

Este stack foi extraído do monorepo da API (`oficina-mecanica-api/infra`).

## Por que PostgreSQL gerenciado

PostgreSQL 15 foi escolhido pela robustez em consultas complexas, suporte a tipos avançados (JSONB, arrays), conformidade com o padrão SQL e integração nativa com o Eloquent ORM. O uso do RDS gerenciado entrega backups automáticos, alta disponibilidade e patching sem operação manual.

## Tecnologias

| Tecnologia | Papel |
|---|---|
| Terraform (≥ 1.3) | Provisionamento da infraestrutura AWS |
| AWS RDS PostgreSQL 15 | Banco de dados gerenciado |
| AWS VPC / Security Groups | Rede privada e restrição de acesso (porta 5432) |
| GitHub Actions | Pipeline CI/CD (`terraform plan` no PR → `apply` em `homolog`/`main`) |

## Recursos provisionados

| Recurso | Detalhe |
|---|---|
| `aws_db_instance` | PostgreSQL 15, db.t3.micro, 20 GB, subnets privadas |
| `aws_db_subnet_group` | Grupo de subnets da VPC do laboratório |
| `aws_security_group` | Acesso à porta 5432 restrito ao CIDR da VPC |

## Execução / Deploy

```bash
cp terraform.tfvars.example terraform.tfvars
# edite subnet_ids, db_username e db_password (AWS Academy: subnets da VPC do lab)

terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

O deploy é automatizado via GitHub Actions nas branches `homolog` (homologação) e `main` (produção).

Secrets necessários no GitHub: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`, `TF_VAR_SUBNET_IDS` (JSON, ex. `["subnet-a","subnet-b"]`), `TF_VAR_DB_USERNAME`, `TF_VAR_DB_PASSWORD`.

## Diagrama

```
Lambda auth ──┐
              ├──▶ RDS PostgreSQL 15 (este repositório)
API no EKS ───┘
```

## Regras de contribuição

Branch `main` protegida. Todo merge via **Pull Request** com aprovação de outro membro. Nunca commitar `terraform.tfvars` nem state com segredos.

## Time — Grupo 183

Roberta Lima (Tech Lead) · Gustavo Delfino (Infra/CI-CD) · David Tavares (Infra/CI-CD) · Johny David (Aplicação)
