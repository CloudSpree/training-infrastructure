variable "namespace" {
  type    = string
  default = "prometheus"
}

variable "name" {
  type    = string
  default = "kube-prometheus-stack"
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
  default = "34.8.0"
}
