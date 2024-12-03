## Moduł database

### Skonfiguruj zmienne środowiskowe

Ustaw w terminalu wartości dla `db_username` i `db_password`

```
export TF_VAR_mysql_db_username="<nazwa_usera>"
export TF_VAR_mysql_db_password="<hasło>"
```

### Dodaj subnet IDs

Wylistuj podsieci i ich ID.

```
aws ec2 describe-subnets --query "Subnets[*].{ID:SubnetId, CIDR:CidrBlock, AZ:AvailabilityZone, MapPublicIP:MapPublicIpOnLaunch}" --output table
```

Dodaj subnets IDs w `envs/prod/database/terraform.tfvars`

```
public_subnets = ["<ID>", "<ID>"]
```

### Skonfiguruj dostęp do bazy

Dodaj swój adres IP i adresy IP maszyn wirtualnych, które mają mieć dostęp do bazy w `envs/prod/database/terraform.tfvars`. 

```
allowed_ips = [
    "<IP>/32",
    "<IP>/32"
]
```

### Zainstaluj mysql-client

Przejdź do folderu prod i zainicjuj Terraforma.
Zainstaluj `mysql-client` zgodnie z dokumentacją https://dev.mysql.com/doc/mysql-getting-started/en/
    
```

# Linux (Ubuntu)
apt-get install mysql

# MacOS
brew install mysql
```
    
Przejdź do folderu prod i zainicjuj Terraforma.
    
```
terraform init
```

Wykonaj deploy.
    
```
terraform apply
```
    
Wylistuj dostępne bazy RDS:

```
aws rds describe-db-instances --output table
```