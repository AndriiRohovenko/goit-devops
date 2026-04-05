# Lesson 5 — Terraform (AWS)

Що саме створюється:

- **S3** — щоб зберігати файл стану Terraform (`terraform.tfstate`) у безпечному місці
- **DynamoDB** — щоб Terraform “блокував” стан (щоб двоє людей не запускали `apply` одночасно)
- **VPC** — мережа + 3 публічні та 3 приватні підмережі + Internet Gateway + NAT Gateway + маршрути
- **ECR** — репозиторій для Docker-образів


## Структура

```
lesson-5/
├── main.tf
├── variables.tf
├── terraform.tfvars
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

3. Перевірте регіон у [terraform.tfvars](lesson-5/terraform.tfvars): поле `aws_region` використовується для AWS provider. Для цього проєкту бекенд у [backend.tf](lesson-5/backend.tf) має бути в тому самому регіоні, але Terraform backend не читає звичайні `var.*` змінні.

4. У [terraform.tfvars](lesson-5/terraform.tfvars) поле `backend_force_destroy = true` дозволяє в кінці видалити backend bucket разом з файлами state, але тільки після перемикання Terraform назад на local state.

## Перший запуск (важливо)

Є нюанс: Terraform не зможе підключити S3-бекенд, якщо S3 bucket і DynamoDB table ще не існують.
Тому перший запуск робиться у 2 кроки.

Перейдіть в папку проєкту:

```bash
cd lesson-5
```

### Крок 1 — створити S3 + DynamoDB (локально)

Тимчасово вимкніть backend у [backend.tf](lesson-5/backend.tf) - закоментуйте весь блок `terraform { backend "s3" { ... } }`.

Після цього ініціалізуйте local state:

```bash
rm -rf .terraform
terraform init
```

Створюємо тільки бекенд-ресурси:

```bash
terraform apply -target=module.s3_backend
```

### Крок 2 — підключити S3 бекенд і перенести стан

Розкоментуйте backend-блок у [backend.tf](lesson-5/backend.tf).

Перевірте, що в [backend.tf] значення `bucket` і `dynamodb_table` такі самі, як у [terraform.tfvars](terraform.tfvars) (поля `bucket_name` і `table_name`).

Підключаємо бекенд і переносимо стан:

```bash
terraform init -migrate-state
```

Після цього можна запускати все:

```bash
terraform plan
terraform apply
```

## Як коректно видалити все

Не видаляйте backend bucket, поки Terraform ще використовує S3 backend. Спочатку знищіть звичайні ресурси, потім перемкніться на local state і тільки після цього видаляйте backend.

### Крок 1 — знищити VPC та ECR, залишивши backend живим

```bash
terraform destroy -target=module.vpc -target=module.ecr
```

### Крок 2 — переключити Terraform на local state

Збережіть поточний remote state локально:

```bash
terraform state pull > terraform.tfstate
```

Потім закоментуйте backend-блок у [backend.tf](lesson-5/backend.tf) і переведіть Terraform на local state:

```bash
rm -rf .terraform
terraform init -reconfigure
```

### Крок 3 — видалити backend-ресурси

```bash
terraform destroy -target=module.s3_backend
```

Після цього можна прибрати локальні тимчасові файли state:

```bash
rm -f terraform.tfstate terraform.tfstate.backup
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

- Назва S3 bucket має бути **унікальною в усьому AWS**. Якщо Terraform каже, що bucket вже існує — змініть `bucket_name` в [terraform.tfvars](terraform.tfvars) та значення `bucket` в [backend.tf](backend.tf).

## Після перевірки (щоб не було витрат)

```bash
terraform destroy
```

Якщо знищите S3/DynamoDB, то наступного разу знову робіть “Перший запуск (2 кроки)”.
