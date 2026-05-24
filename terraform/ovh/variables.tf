variable "os_auth_url" {
  description = "OpenStack auth URL"
  type        = string
}

variable "os_domain_name" {
  description = "OpenStack domain name"
  type        = string
  default     = "Default"
}

variable "os_tenant_id" {
  description = "OpenStack tenant/project ID"
  type        = string
  sensitive   = true
}

variable "os_tenant_name" {
  description = "OpenStack tenant/project name"
  type        = string
  sensitive   = true
}

variable "os_username" {
  description = "OpenStack username"
  type        = string
  sensitive   = true
}

variable "os_password" {
  description = "OpenStack password"
  type        = string
  sensitive   = true
}

variable "os_region" {
  description = "OpenStack region"
  type        = string
}
