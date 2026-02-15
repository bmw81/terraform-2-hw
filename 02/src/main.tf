resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
  route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_vpc_subnet" "db" {
  name           = var.vpc_name_db
  zone           = var.zone_b
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.db_cidr
  route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_vpc_gateway" "nat_gateway" {
  folder_id      = "b1grbnd43egs57caqic6"
  name = "test-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "rt" {
  folder_id      = "b1grbnd43egs57caqic6"
  name       = "test-route-table"
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}


data "yandex_compute_image" "ubuntu" {
  family = var.image
}

resource "yandex_compute_instance" "platform" {
  # name        = var.vm_web_name
  name        = local.web_vm_name
  platform_id = var.vm_web_platform_standard
  zone        = var.default_zone
  resources {
    cores         = var.vms_resources.vm_web.cores
    memory        = var.vms_resources.vm_web.memory
    core_fraction = var.vms_resources.vm_web.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_nat_status
  }

  metadata = {
    #serial-port-enable = var.vm_web_serial_port_status
    #ssh-keys           = "${var.vm_user}:${var.vm_web_ssh_public_root_key}"
    serial-port-enable  = var.metadata.vms_metadata.serial-port-enable
    ssh-keys            = var.metadata.vms_metadata.ssh-keys
  }

}

resource "yandex_compute_instance" "platform-db" {
  # name        = var.vm_db_name
  name        = local.db_vm_name
  platform_id = var.vm_db_platform_standard
  zone        = var.zone_b
  resources {
    cores         = var.vms_resources.vm_db.cores
    memory        = var.vms_resources.vm_db.memory
    core_fraction = var.vms_resources.vm_db.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.db.id
    nat       = var.vm_db_nat_status
  }

  metadata = {
    #serial-port-enable = var.vm_db_serial_port_status
    #ssh-keys           = "${var.vm_db_user}:${var.vm_db_ssh_public_root_key}"
    serial-port-enable  = var.metadata.vms_metadata.serial-port-enable
    ssh-keys            = var.metadata.vms_metadata.ssh-keys
  }

}
