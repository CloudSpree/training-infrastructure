variable "namespace" {
  type    = string
  default = "argo"
}

variable "name" {
  type    = string
  default = "argo-rollouts"
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
  default = "2.13.0"
}
