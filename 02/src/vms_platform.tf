# vm_web vars

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "VM name"
}

variable "develop-platform" {
  type = string
  default = "develop-platform"
  description = "var for test locals"
}

variable "platform_type_web" {
  type = string
  default = "web"
  description = "var for test locals"
}

variable "vm_web_platform_standard" {
  type        = string
  default     = "standard-v2"
  description = "CPU standard"
}

#variable "vm_web_cores" {
#  type        = number
#  default     = 2
# description = "Number CPU cores"
#}

#variable "vm_web_memory" {
#  type        = number
#  default     = 1
#  description = "RAM value in GB"
#}

#variable "vm_web_core_fraction" {
#  type        = number
#  default     = 5
#  description = "CPU core fraction in percent"
#}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "Is VM preemptible"
}

variable "vm_web_nat_status" {
  type        = bool
  default     = false
  description = "Is NAT on"
}

#variable "vm_web_user" {
#  type        = string
#  default     = "ubuntu"
#  description = "Default Ubutu VM user"
#}

#variable "vm_web_serial_port_status" {
#  type        = number
#  default     = 1
#  description = "Is serial port on"
#}

# vm_db vars

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "DB name"
}

variable "platform_type_db" {
  type = string
  default = "db"
  description = "var for test locals"
}

variable "vm_db_platform_standard" {
  type        = string
  default     = "standard-v2"
  description = "CPU standard"
}

#variable "vm_db_cores" {
#  type        = number
#  default     = 2
#  description = "Number CPU cores"
#}

#variable "vm_db_memory" {
#  type        = number
#  default     = 2
#  description = "RAM value in GB"
#}

#variable "vm_db_core_fraction" {
#  type        = number
#  default     = 20
#  description = "CPU core fraction in percent"
#}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description = "Is VM preemptible"
}

variable "vm_db_nat_status" {
  type        = bool
  default     = false
  description = "Is NAT on"
}

#variable "vm_user" {
#  type        = string
#  default     = "ubuntu"
#  description = "Default Ubutu VM user"
#}

#variable "vm_db_serial_port_status" {
#  type        = number
#  default     = 1
#  description = "Is serial port on"
#}

# ssh vars

#variable "vm_web_ssh_public_root_key" {
#  type        = string
#  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEeUsauATqLdTRpLKLuDRPtOkRrnS5kM9OE+thyS2v5/ mike@mike-Perfectum-Series"
#  description = "ssh-keygen -t ed25519"
#}

#variable "vm_db_ssh_public_root_key" {
#  type        = string
#  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEeUsauATqLdTRpLKLuDRPtOkRrnS5kM9OE+thyS2v5/ mike@mike-Perfectum-Series"
#  description = "ssh-keygen -t ed25519"
#}