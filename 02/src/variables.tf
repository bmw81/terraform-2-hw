###cloud vars


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
  default = "b1g42vvurfj7l2uclca3"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
  default = "b1grbnd43egs57caqic6"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone_b" {
  type = string
  default = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "db_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "vpc_name_db" {
  type        = string
  default     = "db"
  description = "VPC network & subnet name"
}

variable "image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "ubuntu 20.04 image"
}

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
  description     = "CPU parametres"
}

variable "metadata" {
 type = map(object({
    serial-port-enable = number
    ssh-keys           = string
 }))
}

variable "test" {
  type = tuple([ 
    object({ dev1 = tuple([ string, string ]) }),
    object({ dev2 = tuple([ string, string ]) }),
    object({ prod1 = tuple([ string, string ]) })
  ])
}