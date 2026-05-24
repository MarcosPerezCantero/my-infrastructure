resource "openstack_compute_keypair_v2" "my_key" {
  name       = "marcos-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "openstack_compute_instance_v2" "server" {
  name        = "srv-01"
  image_name  = "Ubuntu 24.04"
  flavor_name = "d2-2"
  region      = var.os_region
  key_pair    = openstack_compute_keypair_v2.my_key.name
  network {
    name = "Ext-Net"
  }
}
