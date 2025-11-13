# Vault + Terraform Lab (Persistent Local Vault + Terraform Provider Demo)

A hands-on demonstration of how Terraform integrates with HashiCorp Vault to fetch secrets securely using the Vault provider.

This project shows the full authentication flow, persistent Vault storage, KV v2 secrets, and the Terraform → Vault handshake - all running locally. 

## What This Lab Demonstrates

### Persistent Vault Server
- File-based storage (not dev mode)
- Full init + unseal + token workflow
- Durable KV v2 secrets

### Teraform + Vault Integration
- Vault provider authentication
- Reading secrets from KV v2
- Sensitive output handling
- Provider debugging

### Real Vault Operations
- Enabling secrets engines
- Managing policies (next step)
- Understanding identity/token lifecycle
- Distinguishing KV v1 vs KV v2 paths

### Zero-Cost Setup
Runs fully locally with no Docker Desktop, no cloud bill, and no external dependencies. 

Note: Docker can be used and cloud can be integrated. Due to current machine constraints, Docker was not used for this demo.

## Architecture Overview
Terraform ⇔ Vault flow:

Terraform (Vault Provider)
       |
       | → Authenticate using token
       |
    Vault Server (local, persistent)
       |
       | → Access KV v2 secrets engine
       |
    secret/myapp (api_key)

Key steps in the handshake:
1. Terraform loads Vault provider
2. Provider connects to Vault via VAULT_ADDR
3. Vault authenticates token
4. Provider requests secret/data/myapp
5. Vault returns KV v2 structured data
6. Terraform marks output as sensitive

This mirrors how Terraform interacts with Vault in production, just without HCP Vault or a cloud cluster. 

## Repository Structure
.
├── main.tf
├── variables.tf
├── vault.hcl
├── README.md

Note: Remember, your vault-data/ directory, Terraform state files, tokens, and unseal keys must be excluded via .gitignore.

## Setup Instructions
### 1. Start Persistent Vault
```bash
vault server -config=vault.hcl
```

Keep this window open.

### 2. Initialize & Unseal (New Terminal Window)
```bash
export VAULT_ADDR="http://127.0.0.1:8200"
vault operator init
vault operator unseal
vault operator unseal
vault operator unseal
vault login <root_token>
```

### 3. Enable KV v2 & Create Secret
```bash
vault secrets enable -path=secret kv-v2
vault kv put secret/myapp api_key="sup3r-pr1vat3"
vault kv get secret/myapp
```

### 4. Run Terraform
```bash
terraform init
terraform apply
```

Terraform should output:
``` Apply complete!
```

Your secret will appear as a sensitive value, not plaintext. 

## Key Concepts Learned
### Vault Identity Model
- Init, unseal, root token
- Token-based auth
- KV v2 data format
- Persistent storage vs Dev mode

### Terraform Provider Flow
- Provider configuration
- Data source read behavior
- KV v1 vs KV v2 pathing
- Sensitive output handling
- Provider failure modes & debugging

### Infrastructure-as-Code Patterns

Even though this is a simple demo, it models real IaC workflows:
- Codifying manual processes
- Versioned configuration
- Predictable, repeatable provisioning
- Zero-trust secret retrieval 

## Troubleshooting Section

Error: No secret found at secret/data/myapp
- Issue: You're hitting KV v1.
- Fix: re-enable as KV v2.

```bash
vault secrets disable secret/
vault secrets enable -path=secret kv-v2
```

Error: Server gave HTTP response to HTTPS client
- Issue: Your Vault server is running HTTP only.
- Fix:
```bash
export VAULT_ADDR="http://127.0.0.1:8200"
```

## Next Steps (Phase 2-4)
Phase 2: Terraform Cloud (Remote State)
- Move teraform.tfstate to Terraform Cloud
- Use a workspace
- Demonstrate remote backend migration

Phase 3: Remote Vault Access (ngrok)
- Expose Vault securely to Terraform Cloud using ngrok.

Phase 4: Policies & Roles
Add Vault policies:
- apps
- operators
- admins

Simulates real-world acces control.

Phase 5: Architecture Diagrams
Create a visual architecture diagram as part of the README:
- Terraform
- Vault
- KV
- Provider flow
- Remote backend

## Why I Built This Lab
I wanted hands-on experience with the real Terraform ⇔ Vault workflow, not just dev mode.

This lab helped me understand:

- unseal workflow,
- token lifecycle,
- KV v2 semantics,
- provider debugging logic,
- and how IaC tools communicate with secrets engines.

This demo reflects the same mental models used in Solutions Engineering:
- deep debugging
- clear communication
- system flow reasoning
- mapping root cause to architecture

## Outcome
This lab desmontrates that I can:
- stand up a real Vault cluster,
- integrate Terraform securely,
- debug provider errors end-to-end,
- think in IaC patterns,
- and explain the system clearly across audiences.