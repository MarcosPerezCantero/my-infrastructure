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

# --- Servidor ---

variable "instance_name" {
  description = "Nombre de la instancia"
  type        = string
  default     = "srv-01"
}

variable "image_name" {
  description = "Imagen del sistema operativo"
  type        = string
  default     = "Ubuntu 24.04"
}

variable "flavor_name" {
  description = "Tipo de instancia (CPU/RAM) de OVH Public Cloud"
  type        = string
  default     = "d2-2"
}

variable "network_name" {
  description = "Red pública de OVH"
  type        = string
  default     = "Ext-Net"
}

variable "ssh_public_key_path" {
  description = "Ruta local a la clave pública SSH que se instala en la instancia"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
