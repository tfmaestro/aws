# Moduł Bucket

## Ustaw unikalną nazwę dla S3 bucket

Każdy bucket w chmurze AWS musi posiadać unikalną nazwę w skali całej chmury.
Oznacza to, że nie możesz wykorzystać tej samej nazwy, jaka jest podana w kursie.
Dodaj np. ciąg cyfr/liter na końcu nazwy "tfmaestro-maintenance-page" czyli "tfmaestro-maintenance-page-9w83r9wyf98wyf9".

Nazwe ustaw w envs/prod/static_site.tf

```
module "bucket" {
  source = "../../modules/bucket/"

  bucket_name      = "tfmaestro-maintenance-page"
  region           = "us-east-1"
  force_destroy    = true
  versioning       = true
  main_page_suffix = "index.html"
  not_found_page   = "404.html"
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

