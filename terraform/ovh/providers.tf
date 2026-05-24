terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54"
    }
    ovh = {
      source  = "ovh/ovh"
      version = "~> 0.36"
    }
  }
}

provider "openstack" {
  auth_url    = var.os_auth_url
  domain_name = var.os_domain_name
  tenant_id   = var.os_tenant_id
  tenant_name = var.os_tenant_name
  user_name   = var.os_username
  password    = var.os_password
  region      = var.os_region
}

provider "ovh" {
  endpoint = "ovh-eu"
}
