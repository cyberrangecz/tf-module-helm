variable "acme_contact" {
  type        = string
  description = "Let's encrypt contact email address"
}

variable "application_credential_id" {
  type        = string
  description = "Application credentials ID for accessing OpenStack project (mutually exclusive with aws parameter)"
  default     = ""
}

variable "application_credential_secret" {
  type        = string
  description = "Application credentials secret for accessing OpenStack project (mutually exclusive with aws parameter)"
  sensitive   = true
  default     = ""
}

variable "aws_config" {
  type = object({
    accessKeyId      = string
    secretAccessKey  = string
    region           = string
    availabilityZone = string
    baseVpc          = string
    baseSubnet       = string
    eksSgId          = string
    }
  )
  description = "AWS configuration (mutually exclusive with application_credential_id, application_credential_secret and os_auth_url parameters)"
  sensitive   = true
  default = {
    accessKeyId      = ""
    secretAccessKey  = ""
    region           = "eu-central-1"
    availabilityZone = "eu-central-1a"
    baseVpc          = "BaseNet"
    baseSubnet       = "BaseSubnetA"
    eksSgId          = ""
  }
}

variable "cors_whitelist" {
  type        = list(string)
  description = "A list of origins that are authorized to make cross-site HTTP requests"
  default     = []
}

variable "deploy_head_timeout" {
  type        = number
  description = "Timeout for deploying head helm package in seconds"
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
    providers            = map(string)
    user                 = string
    ansibleNetworkingUrl = string
    ansibleNetworkingRev = string
    }
  )
  description = "Git configuration"
  sensitive   = true
  default = {
    providers            = {}
    user                 = "git"
    ansibleNetworkingUrl = "https://github.com/cyberrangecz/ansible-stage-one.git"
    ansibleNetworkingRev = "v1.0.18"
  }
}

variable "grafana_client_secret" {
  type        = string
  description = "Grafana OIDC client secret"
  default     = ""
  sensitive   = true
}

variable "head_host" {
  type        = string
  description = "FQDN/IP address of node/LB, where head services are running"
}

variable "helm_repository" {
  type        = string
  description = "Repository with head helm packages"
  default     = "oci://ghcr.io/cyberrangecz/stable"
}

variable "certs_version" {
  type        = string
  description = "Version of certs helm package"
  default     = "1.0.0"
}

variable "head_version" {
  type        = string
  description = "Version of head helm package"
  default     = "1.0.0"
}

variable "gen_users_version" {
  type        = string
  description = "Version of gen-users helm package"
  default     = "1.0.0"
}

variable "postgres_version" {
  type        = string
  description = "Version of postgres helm package"
  default     = "1.0.0"
}

variable "man_flavor" {
  type        = string
  description = "Flavor name used for man nodes"
  default     = "standard.small"
}

variable "man_image" {
  type        = string
  description = "OpenStack image used for man nodes"
  default     = "debian-12-x86_64"
}

variable "os_auth_url" {
  type        = string
  description = "OpenStack authentication URL (mutually exclusive with aws parameter)"
  default     = ""
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
    refreshToken     = optional(bool)
    }
  ))
  description = "List of OIDC providers. Set issuerIdentifier and userInfoUrl to empty string if not used."
}

variable "proxy_host" {
  type        = string
  description = "FQDN/IP address of proxy jump host"
}

variable "proxy_key" {
  type        = string
  description = "Base64 encoded proxy jump ssh private key"
  sensitive   = true
}

variable "proxy_user" {
  type        = string
  description = "Username to access proxy jump instance"
  default     = "ubuntu"
}

variable "sandbox_ansible_timeout" {
  type        = number
  description = "Timeout for sandbox provisioning stage"
  default     = 7200
}

variable "self_signed" {
  type        = bool
  description = "Use selfsigned certificates instead of Let's Encrypt for fqdn"
  default     = false
}

variable "smtp_config" {
  type = object({
    smtp_server           = string
    smtp_port             = number
    smtp_encryption       = string
    sender_email          = string
    sender_email_password = string
    }
  )
  description = "SMTP configuration for Sandbox Service notificatins"
  sensitive   = true
  default = {
    smtp_server           = ""
    smtp_port             = 25
    smtp_encryption       = ""
    sender_email          = ""
    sender_email_password = ""
  }
  validation {
    condition     = contains(["SSL", "TSL", "INSECURE", ""], var.smtp_config.smtp_encryption)
    error_message = "The connection type must be one of SSL, TSL, INSECURE or empty string."
  }
}

variable "tls_private_key" {
  type        = string
  description = "Base64 encoded tls private key. If not specified, it will be generated."
  default     = ""
  sensitive   = true
}

variable "tls_public_key" {
  type        = string
  description = "Base64 encoded tls public key. If not specified, it will be generated"
  default     = ""
}

variable "users" {
  type = map(
    object({
      iss              = string
      email            = string
      fullName         = string
      givenName        = string
      familyName       = string
      admin            = bool
      keycloakUsername = string
      keycloakPassword = string
      }
  ))
  description = "Dictionary with users, that should be created in CyberRangeCZ Platform. For users from external OIDC providers, set password to empty string."
  sensitive   = true
}

variable "value_files" {
  type        = list(string)
  description = "List of files containing Helm values"
  default     = ["values.yaml"]
}
