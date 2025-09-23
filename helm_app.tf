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

resource "helm_release" "head" {
  name       = "head"
  namespace  = "crczp"
  repository = var.helm_repository
  chart      = "crczp-head"
  version    = var.head_version

  set = [{
    name  = "global.acmeContact"
    value = var.acme_contact
    },
    {
      name  = "global.guacamoleUserPassword"
      value = random_password.guacamole_user_password.result
    },
    {
      name  = "global.headHost"
      value = var.head_host
    },
    {
      name  = "global.postgres.password"
      value = random_password.postgres_superadmin_password.result
    },
    {
      name  = "crczp-guacamole.guacamole.guacamoleAdminPassword"
      value = random_password.guacamole_admin_password.result
    },
    {
      name  = "crczp-keycloak.grafanaClientSecret"
      value = var.grafana_client_secret
    },
    {
      name  = "crczp-keycloak.keycloakPassword"
      value = random_password.keycloak_password.result
    },
    {
      name  = "sandbox.djangoSecretKey"
      value = random_string.django_secret_key.result
    },
    {
      name  = "sandbox.environments.DJANGO_ADMIN_PASSWORD"
      value = random_password.django_superadmin_password.result
    },
    {
      name  = "crczp-syslog.awsSgId"
      value = var.aws_config.eksSgId != "" ? var.aws_config.eksSgId : ""
    },
    {
      name  = "sandbox.manFlavor"
      value = var.man_flavor
    },
    {
      name  = "sandbox.manImage"
      value = var.man_image
    },
    {
      name  = "sandbox.osApplicationCredentialId"
      value = var.application_credential_id
    },
    {
      name  = "sandbox.osApplicationCredentialSecret"
      value = var.application_credential_secret
    },
    {
      name  = "sandbox.osAuthUrl"
      value = var.os_auth_url
    },
    {
      name  = "sandbox.proxyHost"
      value = var.proxy_host
    },
    {
      name  = "sandbox.proxyPort"
      value = var.proxy_port
    },
    {
      name  = "sandbox.proxyKey"
      value = var.proxy_key
    },
    {
      name  = "sandbox.proxyUser"
      value = var.proxy_user
    },
    {
      name  = "sandbox.sandboxAnsibleTimeout"
      value = var.sandbox_ansible_timeout
    },
    {
      name  = "sandbox.smtpServer"
      value = var.smtp_config.smtp_server
    },
    {
      name  = "sandbox.smtpPort"
      value = var.smtp_config.smtp_port
    },
    {
      name  = "sandbox.smtpEncryption"
      value = var.smtp_config.smtp_encryption
    },
    {
      name  = "sandbox.senderEmail"
      value = var.smtp_config.sender_email
    },
    {
      name  = "sandbox.senderEmailPassword"
      value = var.smtp_config.sender_email_password
  }]
  values = concat(local.value_files_paths, [
    jsonencode(
      {
        global = {
          users         = local.users,
          oidcProviders = var.oidc_providers,
          corsWhitelist = var.cors_whitelist,
        }
        sandbox = {
          gitConfig = var.git_config
          aws       = var.aws_config
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
    helm_release.keycloak_operator
  ]
}
