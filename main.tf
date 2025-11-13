terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.3"
    }
  }
}


provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = var.vault_token
}

data "vault_kv_secret_v2" "myapp" {
  mount = "secret"
  name  = "myapp"
}

# TEMPORARY DEBUG OUTPUT
# Lets us see the structure Terraform actually receives
output "debug_secret" {
  value = data.vault_kv_secret_v2.myapp.data
  sensitive = true
}


# FINAL
# Commented out for now until we can confirm structure
# output "api_key" {
  #value     = data.vault_kv_secret_v2.myapp.data["data"]["api_key"]
  #sensitive = true
#}