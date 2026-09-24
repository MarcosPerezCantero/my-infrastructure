terraform {
  required_version = ">= 1.3"

  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54"
    }
  }
}

# Credenciales por variables TF_VAR_* o cargando el openrc.sh de OVH (OS_*).
# Nunca en archivos del repo.
provider "openstack" {
  auth_url    = var.os_auth_url
  domain_name = var.os_domain_name
  tenant_id   = var.os_tenant_id
  tenant_name = var.os_tenant_name
  user_name   = var.os_username
  password    = var.os_password
  region      = var.os_region
}
