# Lesson 5 — Terraform (AWS)

Це ДЗ створює **базові AWS ресурси** через Terraform.

Що саме створюється:

- **S3** — щоб зберігати файл стану Terraform (`terraform.tfstate`) у безпечному місці
- **DynamoDB** — щоб Terraform “блокував” стан (щоб двоє людей не запускали `apply` одночасно)
- **VPC** — мережа + 3 публічні та 3 приватні підмережі + Internet Gateway + NAT Gateway + маршрути
- **ECR** — репозиторій для Docker-образів

Це ДЗ **не створює** EC2/інстанси, ECS/EKS, бази даних тощо.

## Структура

```
lesson-5/
├── main.tf
├── backend.tf
├── outputs.tf
├── modules/
│   ├── s3-backend/
│   ├── vpc/
│   └── ecr/
└── README.md
```

## Перед стартом

1. Встановіть Terraform і перевірте:

```bash
terraform version
```

2. Налаштуйте доступ до AWS (через AWS CLI), щоб Terraform міг створювати ресурси.

## Перший запуск (важливо)

Є нюанс: Terraform не зможе підключити S3-бекенд, якщо S3 bucket і DynamoDB table ще не існують.
Тому перший запуск робиться у 2 кроки.

Перейдіть в папку проєкту:

```bash
cd lesson-5
```

### Крок 1 — створити S3 + DynamoDB (локально)

Ініціалізація без бекенду:

```bash
terraform init -backend=false
```

Створюємо тільки бекенд-ресурси:

```bash
terraform apply -target=module.s3_backend
```

### Крок 2 — підключити S3 бекенд і перенести стан

Перевірте, що в [backend.tf](backend.tf) значення `bucket` і `dynamodb_table` такі самі, як у [main.tf](main.tf).

Підключаємо бекенд і переносимо стан:

```bash
terraform init -migrate-state
```

Після цього можна запускати все:

```bash
terraform plan
terraform apply
```

## Основні команди

У каталозі `lesson-5`:

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

## Що робить кожен модуль

### modules/s3-backend

- Створює S3 bucket для `terraform.tfstate`
- Вмикає версіонування (щоб була історія змін стейту)
- Вмикає шифрування
- Створює DynamoDB таблицю для “lock”

### modules/vpc

- Створює VPC (мережу)
- Створює 3 public subnet і 3 private subnet
- Додає Internet Gateway для public subnet
- Додає NAT Gateway, щоб private subnet мали вихід в інтернет
- Налаштовує маршрути

### modules/ecr

- Створює ECR репозиторій
- (Опціонально) вмикає сканування образів при пуші (`scan_on_push`)
- Додає базову політику доступу до репозиторію

## Важливо про імена

- Назва S3 bucket має бути **унікальною в усьому AWS**. Якщо Terraform каже, що bucket вже існує — просто змініть назву в [lesson-5/main.tf](main.tf) та [lesson-5/backend.tf](backend.tf).

## Після перевірки (щоб не було витрат)

```bash
terraform destroy
```

Якщо знищите S3/DynamoDB, то наступного разу знову робіть “Перший запуск (2 кроки)”.
