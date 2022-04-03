variable "namespace" {
  type    = string
  default = "argo"
}

variable "name" {
  type    = string
  default = "argocd"
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
  default = "4.5.0"
}

variable "hostname" {
  type = string
}
