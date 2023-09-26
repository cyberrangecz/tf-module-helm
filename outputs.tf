output "keycloak_password" {
  value       = random_password.keycloak_password.result
  description = "Password for Keycloak admin users"
  sensitive   = true
}
