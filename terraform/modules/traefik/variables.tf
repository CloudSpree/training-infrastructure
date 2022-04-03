variable "namespace" {
  type    = string
  default = "traefik"
}

variable "name" {
  type    = string
  default = "traefik"
}

variable "wait" {
  type    = bool
  default = true
}

variable "atomic" {
  type    = bool
  default = true
}

variable "chart_version" {
  type    = string
  default = "10.19.4"
}

variable "port_web" {
  type    = number
  default = 30080
}

variable "port_websecure" {
  type    = number
  default = 30443
}