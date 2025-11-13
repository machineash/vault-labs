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

 output "api_key" {
  value     = data.vault_kv_secret_v2.myapp.data["ap1_k3y"]
  sensitive = true
}