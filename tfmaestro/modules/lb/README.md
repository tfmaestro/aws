## Moduł lb

### Skonfiguruj klucz SSH
Dodaj tag dla reguł firewallowych skonfigurowanych w `modules/ec2_firewall/main.tf`:

```
  tags = {
    Name = "ec2-security-group"
  }
```

Wykonaj deploy maszyn wirtualnych z tą zmianą będąc w `envs/prod/ec2_firewall`

```
terraform apply
```

### Dodaj adresy IP maszyn wirtualnych

Teraz możemy przejść do dodania prywatnych adresów IP maszyn wirtualnych i wykonania deployu konfiguracji dla load balancera w `envs/prod/ec2_firewall/terraform.tfvars`.

```
ec2_instance_ips = [
  "<IP>",
  "<IP>"
]
```

Zainicjuj Terraforma
```
terraform init
```

Wykonaj deploy
```
terraform apply
```
