variable "acme_contact" {
  type        = string
  description = "Let's encrypt contact email address"
}

variable "application_credential_id" {
  type        = string
  description = "Application credentials ID for accessing OpenStack project"
}

variable "application_credential_secret" {
  type        = string
  description = "Application credentials secret for accessing OpenStack project"
}

variable "deploy_head_timeout" {
  type        = number
  description = "Timeout for deploying kypo-crp-head helm package in seconds"
  default     = 3600
}

variable "deploy_longhorn" {
  type        = bool
  description = "Deploy Longhorn helm package"
  default     = false
}

variable "gen_user_count" {
  type        = number
  description = "Number of local users to generate"
}

variable "git_config" {
  type = object({
    type                 = string
    server               = string
    sshPort              = number
    restServerUrl        = string
    user                 = string
    privateKey           = string
    accessToken          = string
    ansibleNetworkingUrl = string
    ansibleNetworkingRev = string
    }
  )
  description = "Git configuration for KYPO. For internal GIT, set privateKey to empty string."
}

variable "guacamole_admin_password" {
  type        = string
  description = "Password of guacamole admin user"
}

variable "guacamole_user_password" {
  type        = string
  description = "Password of guacamole non-admin user"
}

variable "head_host" {
  type        = string
  description = "FQDN/IP address of node/LB, where KYPO head services are running"
}

variable "head_ip" {
  type        = string
  description = "IP address of node/LB, where KYPO head services are running"
}

variable "helm_repository" {
  type        = string
  description = "Repository with KYPO-head helm packages"
  default     = "https://gitlab.ics.muni.cz/api/v4/projects/2358/packages/helm/stable"
}

variable "kypo_certs_version" {
  type        = string
  description = "Version of kypo-certs helm package"
  default     = "1.0.0"
}

variable "kypo_crp_head_version" {
  type        = string
  description = "Version of kypo-crp-head helm package"
  default     = "1.0.0"
}

variable "kypo_gen_users_version" {
  type        = string
  description = "Version of kypo-gen-users helm package"
  default     = "1.0.0"
}

variable "kypo_postgres_version" {
  type        = string
  description = "Version of kypo-postgres helm package"
  default     = "1.0.0"
}

variable "man_flavor" {
  type        = string
  description = "Flavor name used for man nodes"
  default     = "csirtmu.tiny1x2"
}

variable "man_image" {
  type        = string
  description = "OpenStack image used for man nodes"
  default     = "debian-10-man"
}

variable "os_auth_url" {
  type        = string
  description = "OpenStack authentication URL"
}

variable "oidc_providers" {
  type = list(object({
    url              = string
    logoutUrl        = string
    clientId         = string
    label            = string
    issuerIdentifier = string
    userInfoUrl      = string
    responseType     = string
    }
  ))
  description = "List of OIDC providers. Set issuerIdentifier and userInfoUrl to empty string if not used."
}

variable "proxy_host" {
  type        = string
  description = "FQDN/IP address of proxy-jump host"
}

variable "proxy_key" {
  type        = string
  description = "Base64 encoded proxy-jump ssh private key"
}

variable "proxy_user" {
  type        = string
  description = "Username to access proxy-jump instance"
  default     = "ubuntu"
}

variable "sandbox_ansible_timeout" {
  type        = number
  description = "Timeout for sandbox provisioning stage"
  default     = 7200
}

variable "tls_private_key" {
  type        = string
  description = "Base64 encoded tls private key. If not specified, it will be generated."
  default     = ""
}

variable "tls_public_key" {
  type        = string
  description = "Base64 encoded tls public key. If not specified, it will be generated"
  default     = ""
}

variable "users" {
  type = map(
    object({
      iss        = string
      password   = string
      email      = string
      fullName   = string
      givenName  = string
      familyName = string
      admin      = bool
      }
  ))
  description = "Dictionary with with users, that should be created in KYPO. For users from external OIDC providers, set password to empty string."
}

variable "value_files" {
  type        = list(string)
  description = "List of files containing Helm values"
  default     = ["values.yaml"]
}
