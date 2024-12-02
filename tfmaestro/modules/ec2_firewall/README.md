## Moduł firewall

### Skonfiguruj klucz SSH
Stwórz swój nowy plik w `modules/ec2_firewall/ssh/` na wzór pliku `kasia_key.pub` i dodaj tam swój publiczny klucz SSH. Możesz też podmienić plik `kasia_key.pub` na swoją nazwę i dodać tam swój klucz.

Pamiętaj, aby zaktualizować nazwę pliku oraz klucza na Twojej maszynie w `modules/ec2_firewall/main.tf`:

```
resource "aws_key_pair" "kasia_key" {
  key_name   = "kasia-tf"
  public_key = file("${path.module}/ssh/kasia_key.pub")
}
```

Zmień także nazwę klucza w `key_name` jeśli zmieniłeś/aś ją w `resource "aws_key_pair" "kasia_key"`.

```
resource "aws_instance" "main" {
  for_each            = var.ec2_instances
  ami                 = var.ami_id
  instance_type      = each.value.instance_type
  availability_zone   = each.value.availability_zone
  key_name            = aws_key_pair.kasia_key.key_name <- Tutaj zmień
  ...
```

### Dodaj swój adres IP

W regule `allow-ssh-vpn` zdefiniowanej w `envs/prod/vm/terraform.tfvars` dodaj swój stały adres IP.
Moze być to równiez adres IP VPNa jeśli posiadasz stały. 
Jest to niezbędne, aby mozna było zalogować się do utworzonych maszyn po protokole SSH.

```
  "allow-ssh-vpn" = {
    protocol         = "tcp"
    ports            = ["22"]
    priority         = 1002
    description      = "Allow ssh communication via VPN."
    source_ip_ranges = ["<TWOJE_IP>/32"]
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

Wylistuj maszyny wirtualne
```
aws ec2 describe-instances
```

