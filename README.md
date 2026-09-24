# my-infrastructure
Infrastructure as Code — Terraform + Ansible para provisionar y securizar un servidor Linux en OVH Public Cloud.

## Qué incluye

- **Terraform**: crea una instancia Ubuntu 24.04 en OVH de forma reproducible y parametrizable.
- **Ansible**: hardening automático e idempotente del servidor, en 6 capas.

## Estructura

```
├── terraform/ovh/
│   ├── main.tf                    # Instancia compute + keypair
│   ├── variables.tf               # Credenciales (sensibles) y parámetros del servidor
│   ├── providers.tf               # Provider OpenStack (OVH Public Cloud)
│   ├── outputs.tf                 # IP pública del servidor
│   └── terraform.tfvars.example   # Plantilla de parámetros (sin secretos)
└── ansible/
    ├── requirements.yml           # Colecciones necesarias
    ├── group_vars/all.yml         # Variables por defecto
    ├── inventory/hosts.example.yml# Plantilla de inventario (el real no se versiona)
    ├── templates/
    │   ├── 00-hardening.conf.j2   # Configuración de SSH
    │   └── jail-sshd.local.j2     # Jail de fail2ban
    └── playbooks/hardening.yml    # Playbook de securización
```

## Qué hace el hardening

1. **Usuario administrador**: crea `admin_user` con clave SSH y **sudo con contraseña** (nada de `NOPASSWD`). Al final elimina el sudo sin contraseña que cloud-init da al usuario inicial.
2. **SSH**:
   - Configuración en `/etc/ssh/sshd_config.d/00-hardening.conf`. El prefijo `00-` hace que prevalezca sobre `50-cloud-init.conf`, que en las imágenes de OVH reactiva `PasswordAuthentication`.
   - Solo clave pública, root desactivado, `AllowUsers`, puerto personalizado, sin forwarding y `MaxAuthTries 3`.
   - **Se valida con `sshd -t` antes de aplicarse**, y el reinicio se hace con handlers (compatible con la activación por socket de Ubuntu 24.04).
3. **Firewall (UFW)**: deniega toda la entrada salvo SSH, 80 y 443. El puerto SSH nuevo se abre **antes** de mover SSH, se comprueba que responde y solo entonces se cierra el antiguo, para evitar quedarse fuera.
4. **Fail2ban**: banea durante 1 h las IPs que fallan 3 intentos de SSH (backend systemd).
5. **Actualizaciones automáticas** de seguridad (`unattended-upgrades`).
6. **Auditoría** con `auditd`.

> **Docker y UFW**: los puertos que publica Docker (`ports:` en compose) se saltan las reglas de UFW. Publica solo lo imprescindible (p. ej. un proxy en 80/443) y deja el resto de contenedores en redes internas.

## Cómo usarlo

### 1. Terraform

```bash
source openrc.sh                 # credenciales de OVH (no se versiona)
cd terraform/ovh
cp terraform.tfvars.example terraform.tfvars   # ajusta región, tamaño, clave...
terraform init
terraform plan
terraform apply
terraform output server_ip
```

### 2. Ansible

```bash
ansible-galaxy collection install -r ansible/requirements.yml

cp ansible/inventory/hosts.example.yml ansible/inventory/hosts.yml   # pon la IP real
```

Contraseña del administrador (para sudo), cifrada con Vault:

```bash
mkpasswd --method=sha-512            # genera el hash
ansible-vault create ansible/group_vars/vault.yml
#   admin_password_hash: "$6$..."
```

Primera ejecución (usuario inicial de la imagen, puerto 22):

```bash
ansible-playbook -i ansible/inventory/hosts.yml \
  -e @ansible/group_vars/vault.yml --ask-vault-pass \
  ansible/playbooks/hardening.yml
```

Ejecuciones posteriores: en `hosts.yml` cambia `ansible_user` por `admin_user` y `ansible_port` por `ssh_port`, y añade `--ask-become-pass`.

## Variables principales (`ansible/group_vars/all.yml`)

| Variable | Por defecto | Descripción |
|---|---|---|
| `admin_user` | `admin` | Usuario administrador |
| `admin_password_hash` | *(obligatoria)* | Hash de la contraseña para sudo (usa Vault) |
| `admin_ssh_public_key_file` | `~/.ssh/id_ed25519.pub` | Clave pública autorizada |
| `ssh_port` | `2222` | Puerto SSH final |
| `ufw_allowed_ports` | `[80, 443]` | Puertos públicos adicionales |
| `ssh_allowed_users` | `[admin_user]` | Usuarios con acceso SSH (añade aquí un usuario de despliegue) |

## Requisitos

- Terraform >= 1.3
- Ansible >= 2.14 con `ansible.posix` y `community.general`
- Cuenta en OVH Public Cloud
- Clave SSH

## Seguridad del repositorio

- Las credenciales de OVH se pasan por variables de entorno (openrc) y nunca se guardan en el repo.
- No se versionan `*.tfstate`, `*.tfvars`, el inventario real (`hosts.yml`), `openrc.sh` ni los archivos de Vault.
- Solo se incluyen plantillas `*.example` con datos ficticios.
