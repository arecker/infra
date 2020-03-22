locals {
  cert_path = "${path.root}/secrets/cert.pem"
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "config" {
  backend            = "${vault_auth_backend.kubernetes.path}"
  kubernetes_host    = "https://farm-0:6443"
  kubernetes_ca_cert = file(local.cert_path)
}

resource "vault_policy" "chorebot" {
  name = "chorebot"

  policy = <<EOT
path "secret/data/slack/reckerfamily/webhook" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "chorebot" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "chorebot"
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["default"]
  token_policies                   = ["chorebot"]
}

resource "vault_policy" "hub" {
  name = "hub"

  policy = <<EOT
path "secret/data/hub" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "hub" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "hub"
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["default"]
  token_policies                   = ["hub"]
}