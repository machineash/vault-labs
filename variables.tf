# Defined variables

variable "vault_token" {
  description = "Root token for Vault auth"
  type        = string
  sensitive   = true
}