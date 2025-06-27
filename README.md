<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.certs](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cnpg](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.head](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.keycloak_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.longhorn](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.postgres](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.reloader](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.users](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [random_password.guacamole_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.guacamole_user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.keycloak_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_superadmin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.django_secret_key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acme_contact"></a> [acme\_contact](#input\_acme\_contact) | Let's encrypt contact email address | `string` | n/a | yes |
| <a name="input_application_credential_id"></a> [application\_credential\_id](#input\_application\_credential\_id) | Application credentials ID for accessing OpenStack project (mutually exclusive with aws parameter) | `string` | `""` | no |
| <a name="input_application_credential_secret"></a> [application\_credential\_secret](#input\_application\_credential\_secret) | Application credentials secret for accessing OpenStack project (mutually exclusive with aws parameter) | `string` | `""` | no |
| <a name="input_aws_config"></a> [aws\_config](#input\_aws\_config) | AWS configuration (mutually exclusive with application\_credential\_id, application\_credential\_secret and os\_auth\_url parameters) | <pre>object({<br/>    accessKeyId      = string<br/>    secretAccessKey  = string<br/>    region           = string<br/>    availabilityZone = string<br/>    baseVpc          = string<br/>    baseSubnet       = string<br/>    eksSgId          = string<br/>    }<br/>  )</pre> | <pre>{<br/>  "accessKeyId": "",<br/>  "availabilityZone": "eu-central-1a",<br/>  "baseSubnet": "BaseSubnetA",<br/>  "baseVpc": "BaseNet",<br/>  "eksSgId": "",<br/>  "region": "eu-central-1",<br/>  "secretAccessKey": ""<br/>}</pre> | no |
| <a name="input_certs_version"></a> [certs\_version](#input\_certs\_version) | Version of certs helm package | `string` | `"1.0.0"` | no |
| <a name="input_cors_whitelist"></a> [cors\_whitelist](#input\_cors\_whitelist) | A list of origins that are authorized to make cross-site HTTP requests | `list(string)` | `[]` | no |
| <a name="input_deploy_head_timeout"></a> [deploy\_head\_timeout](#input\_deploy\_head\_timeout) | Timeout for deploying head helm package in seconds | `number` | `3600` | no |
| <a name="input_deploy_longhorn"></a> [deploy\_longhorn](#input\_deploy\_longhorn) | Deploy Longhorn helm package | `bool` | `false` | no |
| <a name="input_gen_user_count"></a> [gen\_user\_count](#input\_gen\_user\_count) | Number of local users to generate | `number` | n/a | yes |
| <a name="input_gen_users_version"></a> [gen\_users\_version](#input\_gen\_users\_version) | Version of gen-users helm package | `string` | `"1.0.0"` | no |
| <a name="input_git_config"></a> [git\_config](#input\_git\_config) | Git configuration | <pre>object({<br/>    providers            = map(string)<br/>    user                 = string<br/>    ansibleNetworkingUrl = string<br/>    ansibleNetworkingRev = string<br/>    }<br/>  )</pre> | <pre>{<br/>  "ansibleNetworkingRev": "v1.0.18",<br/>  "ansibleNetworkingUrl": "https://github.com/cyberrangecz/ansible-stage-one.git",<br/>  "providers": {},<br/>  "user": "git"<br/>}</pre> | no |
| <a name="input_grafana_client_secret"></a> [grafana\_client\_secret](#input\_grafana\_client\_secret) | Grafana OIDC client secret | `string` | `""` | no |
| <a name="input_head_host"></a> [head\_host](#input\_head\_host) | FQDN/IP address of node/LB, where head services are running | `string` | n/a | yes |
| <a name="input_head_version"></a> [head\_version](#input\_head\_version) | Version of head helm package | `string` | `"1.0.0"` | no |
| <a name="input_helm_repository"></a> [helm\_repository](#input\_helm\_repository) | Repository with head helm packages | `string` | `"oci://ghcr.io/cyberrangecz/stable"` | no |
| <a name="input_man_flavor"></a> [man\_flavor](#input\_man\_flavor) | Flavor name used for man nodes | `string` | `"standard.small"` | no |
| <a name="input_man_image"></a> [man\_image](#input\_man\_image) | OpenStack image used for man nodes | `string` | `"debian-12-x86_64"` | no |
| <a name="input_oidc_providers"></a> [oidc\_providers](#input\_oidc\_providers) | List of OIDC providers. Set issuerIdentifier and userInfoUrl to empty string if not used. | <pre>list(object({<br/>    url              = string<br/>    logoutUrl        = string<br/>    clientId         = string<br/>    label            = string<br/>    issuerIdentifier = string<br/>    userInfoUrl      = string<br/>    responseType     = string<br/>    refreshToken     = optional(bool)<br/>    }<br/>  ))</pre> | n/a | yes |
| <a name="input_os_auth_url"></a> [os\_auth\_url](#input\_os\_auth\_url) | OpenStack authentication URL (mutually exclusive with aws parameter) | `string` | `""` | no |
| <a name="input_postgres_version"></a> [postgres\_version](#input\_postgres\_version) | Version of postgres helm package | `string` | `"1.0.0"` | no |
| <a name="input_proxy_host"></a> [proxy\_host](#input\_proxy\_host) | FQDN/IP address of proxy jump host | `string` | n/a | yes |
| <a name="input_proxy_key"></a> [proxy\_key](#input\_proxy\_key) | Base64 encoded proxy jump ssh private key | `string` | n/a | yes |
| <a name="input_proxy_port"></a> [proxy\_port](#input\_proxy\_port) | SSH Port of proxy jump host | `string` | `"22"` | no |
| <a name="input_proxy_user"></a> [proxy\_user](#input\_proxy\_user) | Username to access proxy jump instance | `string` | `"ubuntu"` | no |
| <a name="input_sandbox_ansible_timeout"></a> [sandbox\_ansible\_timeout](#input\_sandbox\_ansible\_timeout) | Timeout for sandbox provisioning stage | `number` | `7200` | no |
| <a name="input_self_signed"></a> [self\_signed](#input\_self\_signed) | Use selfsigned certificates instead of Let's Encrypt for fqdn | `bool` | `false` | no |
| <a name="input_smtp_config"></a> [smtp\_config](#input\_smtp\_config) | SMTP configuration for Sandbox Service notificatins | <pre>object({<br/>    smtp_server           = string<br/>    smtp_port             = number<br/>    smtp_encryption       = string<br/>    sender_email          = string<br/>    sender_email_password = string<br/>    }<br/>  )</pre> | <pre>{<br/>  "sender_email": "",<br/>  "sender_email_password": "",<br/>  "smtp_encryption": "",<br/>  "smtp_port": 25,<br/>  "smtp_server": ""<br/>}</pre> | no |
| <a name="input_tls_private_key"></a> [tls\_private\_key](#input\_tls\_private\_key) | Base64 encoded tls private key. If not specified, it will be generated. | `string` | `""` | no |
| <a name="input_tls_public_key"></a> [tls\_public\_key](#input\_tls\_public\_key) | Base64 encoded tls public key. If not specified, it will be generated | `string` | `""` | no |
| <a name="input_users"></a> [users](#input\_users) | Dictionary with users, that should be created in CyberRangeCZ Platform. For users from external OIDC providers, set password to empty string. | <pre>map(<br/>    object({<br/>      iss              = string<br/>      email            = string<br/>      fullName         = string<br/>      givenName        = string<br/>      familyName       = string<br/>      admin            = bool<br/>      keycloakUsername = string<br/>      keycloakPassword = string<br/>      }<br/>  ))</pre> | n/a | yes |
| <a name="input_value_files"></a> [value\_files](#input\_value\_files) | List of files containing Helm values | `list(string)` | <pre>[<br/>  "values.yaml"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_keycloak_password"></a> [keycloak\_password](#output\_keycloak\_password) | Password for Keycloak admin users |
<!-- END_TF_DOCS -->
