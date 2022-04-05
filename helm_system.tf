resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.7.1"
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
  create_namespace = true
  wait             = true
}
