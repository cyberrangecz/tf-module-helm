locals {
  users = [
    for key, value in var.users : {
      iss              = var.users[key].iss
      email            = var.users[key].email
      fullName         = var.users[key].fullName
      givenName        = var.users[key].givenName
      familyName       = var.users[key].familyName
      admin            = var.users[key].admin
      keycloakUsername = var.users[key].keycloakUsername
      keycloakPassword = var.users[key].keycloakPassword
    }
  ]

  value_files_paths = [for value_file in var.value_files : file(value_file)]
}

resource "helm_release" "certs" {
  name             = "certs"
  namespace        = "crczp"
  repository       = var.helm_repository
  chart            = "crczp-certs"
  create_namespace = true
  version          = var.certs_version

  set = [{
    name  = "global.headHost"
    value = var.head_host
    },
    {
      name  = "global.acmeContact"
      value = var.acme_contact
    },
    {
      name  = "global.tlsPrivateKey"
      value = var.tls_private_key
    },
    {
      name  = "global.tlsPublicKey"
      value = var.tls_public_key
    },
    {
      name  = "selfSigned"
      value = var.self_signed
  }]
  depends_on = [
    helm_release.cert_manager
  ]
}

resource "helm_release" "users" {
  name             = "gen-users"
  namespace        = "crczp"
  repository       = var.helm_repository
  chart            = "crczp-gen-users"
  create_namespace = true
  wait             = true
  version          = var.gen_users_version

  set = [{
    name  = "global.headHost"
    value = var.head_host
    },
    {
      name  = "global.userCount"
      value = var.gen_user_count
  }]
}

resource "helm_release" "keycloak_operator" {
  name             = "keycloak-operator"
  namespace        = "crczp"
  chart            = "${path.module}/helm/keycloak-operator"
  create_namespace = true
  wait             = true
}

resource "random_password" "keycloak_password" {
  length  = 20
  special = false
}

resource "random_password" "guacamole_user_password" {
  length  = 20
  special = false
}

resource "random_password" "guacamole_admin_password" {
  length  = 20
  special = false
}

resource "random_password" "postgres_superadmin_password" {
  length  = 20
  special = false
}

resource "random_password" "django_superadmin_password" {
  length  = 20
  special = false
}

resource "random_string" "django_secret_key" {
  length  = 50
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "random_string" "django_secret_key_mitre" {
  length  = 50
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "helm_release" "head" {
  name       = "head"
  namespace  = "crczp"
  repository = var.helm_repository
  chart      = "crczp-head"
  version    = var.head_version

  values = concat(local.value_files_paths, [
    jsonencode(
      {
        global = {
          corsWhitelist         = var.cors_whitelist
          guacamoleUserPassword = random_password.guacamole_user_password.result
          headHost              = var.head_host
          oidcProviders         = var.oidc_providers
          postgres = {
            password = random_password.postgres_superadmin_password.result
          }
          users = local.users
        }
        crczp-guacamole = {
          guacamole = {
            guacamoleAdminPassword = random_password.guacamole_admin_password.result
          }
        }
        crczp-keycloak = {
          grafanaClientSecret = var.grafana_client_secret
          keycloakPassword    = random_password.keycloak_password.result
        }
        crczp-syslog = {
          awsSgId = var.aws_config.eksSgId != "" ? var.aws_config.eksSgId : ""
        }
        mitre = {
          djangoSecretKey = random_string.django_secret_key_mitre.result
        }
        sandbox = {
          gitConfig       = var.git_config
          aws             = var.aws_config
          djangoSecretKey = random_string.django_secret_key.result
          netbird = {
            clientManagementUrl = var.netbird_client_management_url
          }
          environments = {
            DJANGO_ADMIN_PASSWORD = random_password.django_superadmin_password.result
          }
          openstack           = var.openstack_config
          proxyHost           = var.proxy_host
          proxyKey            = var.proxy_key
          proxyPort           = var.proxy_port
          proxyUser           = var.proxy_user
          senderEmail         = var.smtp_config.sender_email
          senderEmailPassword = var.smtp_config.sender_email_password
          smtpEncryption      = var.smtp_config.smtp_encryption
          smtpPort            = var.smtp_config.smtp_port
          smtpServer          = var.smtp_config.smtp_server
        }
      }
    )
  ])
  create_namespace = true
  atomic           = true
  timeout          = var.deploy_head_timeout
  depends_on = [
    helm_release.postgres,
    helm_release.certs,
    helm_release.keycloak_operator,
    helm_release.opensearch
  ]
}
