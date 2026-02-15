output "vms_data" {
  value = [
    {
      vm_web = [yandex_compute_instance.platform.network_interface[0].nat_ip_address, yandex_compute_instance.platform.name, yandex_compute_instance.platform.fqdn]
    },
    {
      vm_db = [yandex_compute_instance.platform-db.network_interface[0].nat_ip_address, yandex_compute_instance.platform-db.name, yandex_compute_instance.platform-db.fqdn]
    }
  ]
}