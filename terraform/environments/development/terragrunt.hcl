terraform {}

locals {
  secrets = yamldecode(sops_decrypt_file(find_in_parent_folders("secrets.yaml")))
  values  = yamldecode(file(find_in_parent_folders("values.yaml")))
}

inputs = {
  do_token = local.secrets.digital_ocean.token
  lightstep_token = local.secrets.lightstep.token
}
