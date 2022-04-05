resource "local_file" "kubectl_config" {
  content = templatefile("${path.module}/templates/kubectl-config.tpl", {
    server                  = var.kubernetes_host
    client_certificate_data = var.kubernetes_client_certificate
    client_key_data         = var.kubernetes_client_key
  })
  filename        = "config"
  file_permission = "0600"
}
