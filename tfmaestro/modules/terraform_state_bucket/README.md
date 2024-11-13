# Moduł Bucket

## Ustaw unikalną nazwę bucketów

Każdy bucket w chmurze AWS musi posiadać unikalną nazwę w skali całej chmury.
Oznacza to, że nie możesz wykorzystać tej samej nazwy, jaka jest podana w kursie.
Dodaj np. ciąg cyfr/liter na końcu nazwy "terraform-state-${var.environment}" oraz bucket = "log-state-${var.environment}".

Wejdź do `modules/terraform_state_bucket/main.tf` i wykonaj poniższe czynności:

* Bucket dla stanu -> zaktualizuj wartość dla parametru bucket_prefix

```
resource "aws_s3_bucket" "terraform_state" {
  bucket_prefix = "terraform-state-${var.environment}" <- TUTAJ DODAJ SWOJĄ UNIKALNĄ NAZWĘ
  force_destroy = var.force_destroy

  tags = {
    environment = var.environment
    purpose     = "tf-state"
  }
}
```
* Bucket z logami -> zaktualizuj wartość dla parametru bucket

```
resource "aws_s3_bucket" "log_bucket" {
  bucket = "log-state-${var.environment}" <- TUTAJ DODAJ SWOJĄ UNIKALNĄ NAZWĘ
  
  tags = {
    environment = var.environment
    purpose     = "state-logging"
  }
}
```

Zainicjuj Terraforma

```
terraform init
```
Wykonaj deploy

```
terraform apply
```

Na tym etapie zostały utworzone 2 buckety dla plików stanu i logów.

Wylistuj sobie utworzone buckety i skopiuj ID dla bucketu pod plik stanu.
Będzie on potrzebny przy migracji w następnym kroku.
```
aws s3 ls
```


## Migracja stanu lokalnego do bucketa

Kolejny krok to migracja plików stanu z Twojego komputera do chmury na utworzony bucket S3.
Aby to zrobić postępuj zgodnie z instrukcjami:

Dodaj bucket ID w pliku `envs/prod/backend.tf` oraz/lub `envs/dev/backend.tf`

Aktualnie konfiguracja powinna wyglądać tak, czyli wartość dla bucket musi być podmieniona.
```
terraform {
    backend "s3" {
        bucket = "<BUCKET_ID>"
        key = "terraform.tfstate"
        region = "us-east-1"
    }
}
```
Tak mniej więcej powinna wyglądać konfiguracja `backend.tf` z właściwym ID

```
 terraform {
     backend "s3" {
         bucket = "terraform-state-prod20240941" <- TUTAJ PODAJ SWOJE ID
         key = "terraform.tfstate"
         region = "us-east-1"
     }
 }
```

Zmigruj stan do bucketa inicjalizując Terraforma jeszcze raz.
Postępuj zgodnie z instrukcją w terminalu.

```
terraform init
```

Ponownie wykonaj deploy

```
terraform apply
```
