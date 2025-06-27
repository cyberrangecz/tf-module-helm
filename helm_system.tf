resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.16.2"
  create_namespace = true
  wait             = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "reloader" {
  name             = "reloader"
  namespace        = "reloader"
  repository       = "https://stakater.github.io/stakater-charts"
  chart            = "reloader"
  version          = "1.2.0"
  create_namespace = true
  wait             = true
}

resource "helm_release" "longhorn" {
  count            = var.deploy_longhorn ? 1 : 0
  name             = "longhorn"
  namespace        = "longhorn-system"
  repository       = "https://charts.longhorn.io"
  chart            = "longhorn"
  create_namespace = true
  wait             = true
}

resource "helm_release" "cnpg" {
  name       = "cnpg"
  namespace  = "cnpg-system"
  repository = "https://cloudnative-pg.github.io/charts"
  chart      = "cloudnative-pg"
  version    = "0.24.0"

  create_namespace = true

  set {
    name  = "config.clusterWide"
    value = "false"
  }
}

resource "helm_release" "postgres" {
  name       = "postgres"
  namespace  = "cnpg-system"
  repository = var.helm_repository
  chart      = "crczp-postgres"
  values     = [file("value-files/${terraform.workspace}-postgres.yaml")]

  set {
    name  = "cluster.superuserPassword"
    value = random_password.postgres_superadmin_password.result
  }

  depends_on = [
    helm_release.cnpg
  ]
}
