resource "openstack_compute_keypair_v2" "admin" {
  name       = "${var.instance_name}-key"
  public_key = file(pathexpand(var.ssh_public_key_path))
}

resource "openstack_compute_instance_v2" "server" {
  name        = var.instance_name
  image_name  = var.image_name
  flavor_name = var.flavor_name
  region      = var.os_region
  key_pair    = openstack_compute_keypair_v2.admin.name

  network {
    name = var.network_name
  }

  metadata = {
    managed_by = "terraform"
  }
}
