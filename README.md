# my-infrastructure
Infrastructure as Code — Terraform + Ansible for server provisioning, hardening, CI/CD and monitoring

Infraestructura como código para provisionar y securizar un servidor Linux en OVH Public Cloud.

## Qué incluye

- **Terraform** — Crea una instancia Ubuntu 24.04 en OVH de forma reproducible
- **Ansible** — Hardening automático del servidor con 6 capas de seguridad

## Estructura

```
├── terraform/ovh/
│   ├── main.tf          # Recurso: instancia compute
│   ├── variables.tf     # Variables (credenciales por entorno)
│   ├── providers.tf     # Providers OpenStack + OVH
│   └── outputs.tf       # Output: IP pública del servidor
├── ansible/
│   ├── inventory/
│   │   └── hosts.yml    # Inventario (IP, usuario, puerto SSH)
│   └── playbooks/
│       └── hardening.yml # Playbook de securización
```

## Qué hace el hardening

1. **Usuario dedicado** — Crea usuario con sudo, elimina acceso directo de root
2. **SSH hardening** — Puerto personalizado, login solo por clave, root desactivado
3. **Firewall (UFW)** — Solo permite SSH, HTTP y HTTPS, deniega todo lo demás
4. **Fail2ban** — Banea IPs tras 3 intentos fallidos de SSH (1h de ban)
5. **Actualizaciones automáticas** — Parches de seguridad sin intervención manual
6. **Auditoría (auditd)** — Registro de eventos del sistema

## Cómo usarlo

### 1. Terraform

```bash
# Cargar credenciales OVH
source openrc.sh

# Crear la instancia
cd terraform/ovh
terraform init
terraform plan
terraform apply
```

### 2. Ansible

Edita `ansible/inventory/hosts.yml` con la IP de tu servidor, después:

```bash
ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/hardening.yml
```

## Requisitos

- Terraform >= 1.0
- Ansible >= 2.10
- Cuenta en OVH Public Cloud
- Clave SSH generada

## Seguridad

Las credenciales de OVH se pasan por variables de entorno (openrc), nunca se guardan en el repo. Los archivos `.tfstate` y `.tfvars` están excluidos en `.gitignore`.
```
