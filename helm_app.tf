locals {
  users = [
    for key, value in var.users : {
      sub        = key
      iss        = var.users[key].iss
      password   = try(var.users[key].password, "")
      email      = var.users[key].email
      fullName   = var.users[key].fullName
      givenName  = var.users[key].givenName
      familyName = var.users[key].familyName
      admin      = var.users[key].admin
    }
  ]
  value_files_paths = [for value_file in var.value_files : file(value_file)]
}

resource "helm_release" "kypo_certs" {
  name             = "kypo-certs"
  namespace        = "kypo"
  repository       = var.helm_repository
  chart            = "kypo-certs"
  create_namespace = true
  version          = var.kypo_certs_version

  set {
    name  = "global.headHost"
    value = var.head_host
  }
  set {
    name  = "global.acmeContact"
    value = var.acme_contact
  }
  set {
    name  = "global.tlsPrivateKey"
    value = var.tls_private_key
  }
  set {
    name  = "global.tlsPublicKey"
    value = var.tls_public_key
  }
  depends_on = [
    helm_release.cert_manager
  ]
}

resource "helm_release" "kypo_postgres" {
  name             = "kypo-postgres"
  namespace        = "kypo"
  repository       = var.helm_repository
  chart            = "kypo-postgres"
  create_namespace = true
  wait             = true
  values           = local.value_files_paths
  version          = var.kypo_postgres_version
  depends_on = [
    helm_release.longhorn
  ]
}

resource "helm_release" "kypo_users" {
  name             = "kypo-gen-users"
  namespace        = "kypo"
  repository       = var.helm_repository
  chart            = "kypo-gen-users"
  create_namespace = true
  wait             = true
  version          = var.kypo_gen_users_version

  set {
    name  = "global.headHost"
    value = var.head_host
  }
  set {
    name  = "global.userCount"
    value = var.gen_user_count
  }
}

resource "helm_release" "kypo_crp_head" {
  name       = "kypo-crp-head"
  namespace  = "kypo"
  repository = var.helm_repository
  chart      = "kypo-crp-head"
  version    = var.kypo_crp_head_version

  set {
    name  = "global.acmeContact"
    value = var.acme_contact
  }
  set {
    name  = "global.guacamoleUserPassword"
    value = var.guacamole_user_password
  }
  set {
    name  = "global.headHost"
    value = var.head_host
  }

  set {
    name  = "kypo-guacamole.guacamole.guacamoleAdminPassword"
    value = var.guacamole_admin_password
  }

  set {
    name  = "sandbox.kypoHeadIp"
    value = var.head_ip
  }
  set {
    name  = "sandbox.manFlavor"
    value = var.man_flavor
  }
  set {
    name  = "sandbox.osApplicationCredentialId"
    value = var.application_credential_id
  }
  set {
    name  = "sandbox.osApplicationCredentialSecret"
    value = var.application_credential_secret
  }
  set {
    name  = "sandbox.osAuthUrl"
    value = var.os_auth_url
  }
  set {
    name  = "sandbox.proxyHost"
    value = var.proxy_host
  }
  set {
    name  = "sandbox.proxyKey"
    value = var.proxy_key
  }
  set {
    name  = "sandbox.proxyUser"
    value = var.proxy_user
  }
  values = concat(local.value_files_paths, [
    jsonencode(
      {
        global = {
          users         = local.users,
          oidcProviders = var.oidc_providers,
        }
        sandbox = {
          gitConfig = var.git_config
        }
      }
    )
  ])
  create_namespace = true
  atomic           = true
  timeout          = var.deploy_head_timeout
  depends_on = [
    helm_release.kypo_postgres,
    helm_release.kypo_certs
  ]
}
