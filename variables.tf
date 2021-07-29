#aws environment definition variables
variable "aws_region" {
  default     = "us-east-2"
  type        = string
  description = "The aws region to deploy the infrastructure"
  validation {
    condition     = can(regex("([a-z]{2})-(.*)-([0-9])", var.aws_region))
    error_message = "The aws region must be entered in acceptable format, ex: us-east-2."
  }
}
variable "aws_env" {
  default = "dev"
  type    = string
  validation {
    condition     = can(regex("dev", var.aws_env)) || can(regex("prod", var.aws_env)) || can(regex("test", var.aws_env))
    error_message = "The environment value must be either \\dev\\test\\prod."
  }
}
variable "aws_core_account_number" {
  type        = string
  description = "The aws account number on which core application infra is to setup/exists"
}
variable "aws_secondary_account_number" {
  type        = list(string)
  description = "The aws account number on which carrier infra is to setup"
}
variable "other_aws_account" {
  type        = bool
  description = "The app_cluster and blockchain_cluster are in same aws account"
}
variable "aws_user_arn" {
  type        = string
  description = "The iam user will have access to s3 bucket and kms key"
}
variable "aws_role_arn" {
  type        = string
  description = "The iam role which will have access to s3 bucket and kms key"
}
variable "application_name" {
  type        = string
  default     = "openidl"
  description = "The name of the application"
}
#variables related to VPC
variable "vpc_cidr" {
  description = "The VPC network CIDR Block to be created"
}
variable "private_subnets" {
  type        = list(string)
  description = "The list of private subnet cidrs to be created"
}
variable "public_subnets" {
  type        = list(string)
  description = "The list of public subnet cidrs to be created"
}
variable "availability_zones" {
  type        = list(string)
  description = "The list of availability zones aligning to the numbers with public/private subnets defined"
}
variable "default_nacl_rules" {
  type        = map(any)
  description = "The list of default access rules to be allowed"
  default     = {}
}
variable "public_nacl_rules" {
  type        = map(any)
  description = "The list of network access rules to be allowed for public subnets"
}
variable "private_nacl_rules" {
  type        = map(any)
  description = "The list of network access rules to be allowed for private subnets"
}
variable "default_sg_rules" {
  type        = map(any)
  description = "The list of default traffic flow to be opened in security group"
}
#variable defines whether an app_cluster or blockchain_cluster
variable "cluster_type" {
  type        = string
  description = "The cluster type should be setup in the environment (app_cluster/blockchain_cluster"
  validation {
    condition     = can(regex("app_cluster", var.cluster_type)) || can(regex("blockchain_cluster", var.cluster_type))
    error_message = "The cluster type will be either app_cluster or blockchain_cluster."
  }
}
#variables related to transit gateway
variable "tgw_routes" {
  type        = list(any)
  description = "The list of network routes to be allowed/blocked in the transit gateway route table"
  default     = []
}
variable "tgw_ram_resource_share_id" {
  type        = string
  default     = ""
  description = "The AWS resource access manager resource share id of the transit gateway to connect with for this blockchain_cluster"
}
variable "transit_gateway_id" {
  type        = string
  default     = ""
  description = "The transit gateway id to be attached with the network"
}
variable "transit_gateway_route_table_id" {
  type        = string
  default     = ""
  description = "The transit gateway route table id"
}
variable "tgw_destination_cidr" {
  type        = list(any)
  default     = []
  description = "The list of network routes to route via transit gateway"
}
####variables from codeset
variable "instance_type" {
  description = "The instance type of the bastion host"
  type        = string
  default     = "t2.small"
}
variable "ec2_keypair" {
  description = "The ssh keypair for the instances"
  type        = string
  default     = "ec2_keypair"
}
variable "instance_ami_id" {
  description = "The ami id for the ec2 instance"
  type        = string
  default     = "ami-0d5eff06f840b45e9"
}
variable "instance_count" {
  description = "The number of instances to launch"
  type        = number
  default     = 1
}
variable "app_service_sg" {
  description = "The application security group"
  default     = "app_service_sg"
  type        = string
}
variable "storage_type" {
  description = "The ebs volume storage type"
  type        = string
  default     = "gp2"
}
variable "storage_size" {
  description = "The ebs volume storage size"
  type        = string
  default     = "30"
}
variable "root_block_device_volume_type" {
  description = "root_block_device volume type"
}
variable "root_block_device_volume_size" {
  description = "root_block_device volume Size"
}
variable "ebs_block_device_volume_type" {
  description = "ebs_block_device_volume type"
}

variable "ebs_block_device_volume_size" {
  description = "ebs_block_device_volume size"
}
variable "cluster_version" {
  description = "The hasicorp terraform eks module version"
  type        = string
  default     = "1.19"
}
variable "eks_worker_instance_type" {
  description = "The eks cluster worker node instance type"
  type        = string
}
variable "s3_owner" {
  description = "The iam owner of the s3 bucket"
  default     = ""
  type        = string
}
variable "tenancy" {
  description = "The tenancy of the instance (if the instance is running in a VPC). Available values: default, dedicated, host."
  type        = string
  default     = "default"
}
variable "cluster_encryption_config_resources" {
  type        = list(any)
  default     = ["secrets"]
  description = "Cluster Encryption Config Resources to encrypt, e.g. ['secrets']"
}
variable "cluster_encryption_config" {
  description = "Configuration block with encryption configuration for the cluster. See examples/secrets_encryption/main.tf for example format"
  type = list(object({
    provider_key_arn = string
    resources        = list(string)
  }))
  default = []
}
variable "kms_key_arn" {
  default     = ""
  description = "KMS key ARN to use if you want to encrypt EKS node root volumes"
  type        = string
}
variable "kubeconfig_output_path" {
  description = "Where to save the Kubectl config file (if `write_kubeconfig = true`). Assumed to be a directory if the value ends with a forward slash `/`."
  type        = string
  default     = "./kubeconfig_file/"
}
variable "tf_backend_s3_bucket" {
  type        = string
  default     = ""
  description = "The s3 bucket to store terraform state files"
}
variable "eks_worker_group_sg_mgmt_one" {
  //type        = string
  //default     = ""
  description = "eks_worker_group_sg_mgmt_one"
}
variable "eks_worker_group_sg_mgmt_two" {
  //type        = string
  //default     = ""
  description = "eks_worker_group_sg_mgmt_two"
}
variable "ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack."
  type        = string
  default     = "ipv4"
}
variable "eks_worker_name_1" {
  description = "The name of the EKS worker 1"
}
variable "eks_worker_name_2" {
  description = "The name of the EKS worker 2"
}
variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}
variable "target_group_sticky" {
  description = "Whether to enable/disable stickiness for NLB"
  type        = bool
  default     = true
}

#aws cognito variables
#aws cognito application client specific variables
variable "client_app_name" {
  type        = string
  description = "The name of the application client"
  default     = ""
}
variable "client_allowed_oauth_flows" {
  type        = list(string)
  description = "The list of allowed oauth flows"
  #default = ["code", "implicit", "client_credentials"]
  default = []
}
variable "client_callback_urls" {
  type        = list(string)
  description = "The list of callback urls"
  default     = []
}
variable "client_logout_urls" {
  type        = list(string)
  description = "The list of signout urls"
  default     = []
}
variable "client_default_redirect_url" {
  type        = string
  description = "The default url to redirect"
  default     = ""
}
variable "client_allowed_oauth_scopes" {
  type        = list(string)
  description = "The list of allowed OAuth scopes (phone, email, openid, profile, and aws.cognito.signin.user.admin)"
  default     = []
  #default = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
}
variable "client_explicit_auth_flows" {
  type        = list(string)
  description = "List of authentication flows (ADMIN_NO_SRP_AUTH, CUSTOM_AUTH_FLOW_ONLY, USER_PASSWORD_AUTH, ALLOW_ADMIN_USER_PASSWORD_AUTH, ALLOW_CUSTOM_AUTH, ALLOW_USER_PASSWORD_AUTH, ALLOW_USER_SRP_AUTH, ALLOW_REFRESH_TOKEN_AUTH)"
  default     = []
}
variable "client_generate_secret" {
  type        = bool
  description = "The secret is required to generate"
  default     = true
}
variable "client_prevent_user_existence_errors" {
  type        = string
  description = "Choose which errors and responses are returned by Cognito APIs during authentication, account confirmation, and password recovery when the user does not exist in the user pool. When set to ENABLED and the user does not exist, authentication returns an error indicating either the username or password was incorrect, and account confirmation and password recovery return a response indicating a code was sent to a simulated destination. When set to LEGACY, those APIs will return a UserNotFoundException exception if the user does not exist in the user pool."
  default     = "ENABLED"
  #LEGACY is alternate choice
}
variable "client_read_attributes" {
  type        = list(string)
  description = "The list of attributes of an user allowed to read by an application"
  default     = []
}
variable "client_write_attributes" {
  type        = list(string)
  description = "The list of attributes of an user allowed to write by an application"
  default     = []
}
variable "client_supported_idp" {
  type        = list(string)
  description = "The list of identity providers to be supported"
  default     = []
}
variable "client_allowed_oauth_flows_user_pool_client" {
  type        = bool
  description = "Whether the client is allowed to follow the OAuth protocol when interacting with Cognito user pools"
  default     = true
}
variable "client_refresh_token_validity" {
  description = "The time limit in days refresh tokens are valid for. Must be between 60 minutes and 3650 days. This value will be overridden if you have entered a value in `token_validity_units`"
  type        = number
  default     = 30
}
variable "client_id_token_validity" {
  description = "Time limit, between 5 minutes and 1 day, after which the ID token is no longer valid and cannot be used. Must be between 5 minutes and 1 day. Cannot be greater than refresh token expiration. This value will be overridden if you have entered a value in `token_validity_units`."
  type        = number
  default     = 60
}
variable "client_token_validity_units" {
  description = "Configuration block for units in which the validity times are represented in. Valid values for the following arguments are: `seconds`, `minutes`, `hours` or `days`."
  type        = any
  default = {
    access_token  = "hours"
    id_token      = "hours"
    refresh_token = "days"
  }
}
variable "client_access_token_validity" {
  description = "Time limit, between 5 minutes and 1 day, after which the access token is no longer valid and cannot be used."
  type        = number
  default     = 60
}
#aws cognito domain (default/custom) specific variables
variable "cognito_domain" {
  type        = string
  description = "The cognito or custom domain to be used"
  default     = ""
}
variable "acm_cert_arn" {
  type        = string
  description = "The acm certificate arn of the custom domain"
  default     = ""
}
#aws cognito user pool specific variables
variable "userpool_recovery_mechanisms" {
  description = "The list of Account Recovery Options"
  type        = list(any)
  default     = []
}
variable "userpool_allow_admin_create_user_only" {
  type        = bool
  description = "Is the administrator allowed to create user profiles or users can sign themselves via app"
  default     = false
}
variable "userpool_alais_attributes" {
  type        = list(string)
  description = "The attributes supported as an alias for the userpool"
  default     = []
}
variable "userpool_username_attributes" {
  type        = list(string)
  description = "Whether email addresses or phone numbers can be specified as usernames when a user signs up"
  default     = []
}
variable "userpool_auto_verified_attributes" {
  type        = list(any)
  description = "The attributes to auto verify"
  default     = ["email"]
}
variable "userpool_challenge_required_on_new_device" {
  type        = bool
  description = "Whether a challenge is required on a new device"
  default     = true
}
variable "userpool_device_only_remembered_on_user_prompt" {
  type        = bool
  description = "Whether a device is only remembered on user prompt"
  default     = true
}
variable "userpool_email_config" {
  type        = map(any)
  description = "The details of email config set from SES"
  default     = {}
}
variable "userpool_email_verficiation_subject" {
  type        = string
  description = "The email verification subject"
  default     = ""
}
variable "userpool_email_verficiation_message" {
  type        = string
  description = "The email verification message"
  default     = ""
}
variable "userpool_mfa_configuration" {
  type        = string
  default     = "OFF"
  description = "The MFA is required"
}
variable "userpool_software_token_mfa_enabled" {
  type        = bool
  default     = false
  description = "Are you enabling software token mfa"
}
variable "password_policy_minimum_length" {
  type        = number
  default     = 8
  description = "The password minimum length"
}
variable "password_policy_require_lowercase" {
  type        = bool
  default     = true
  description = "The password requires lowercase char"
}
variable "password_policy_require_numbers" {
  type        = bool
  default     = true
  description = "The password requires a number in it"
}
variable "password_policy_require_symbols" {
  type        = bool
  default     = true
  description = "The password requires a symbol in it"
}
variable "password_policy_require_uppercase" {
  type        = bool
  default     = true
  description = "The password requires a uppercase character"
}
variable "password_policy_temporary_password_validity_days" {
  type        = number
  default     = 5
  description = "The temporary password validity days in number"
}
variable "userpool_advanced_security_mode" {
  type        = string
  default     = "AUDIT"
  description = "The userpool advanced security mode"
}
variable "userpool_enable_username_case_sensitivity" {
  type        = bool
  default     = false
  description = "The usernames in the userpool is case-sensitive?"
}
variable "userpool_name" {
  type        = string
  description = "The name of the cognito userpool to create"
  default     = ""
}
/*
variable "email_address" {
  type        = string
  description = "The email address to be used in Cognito referred as from-email & reply-to-email address"
  default     = ""
}*/
variable "bastion_host_sg_ingress" {
  type    = list(any)
  default = []
  description = "The list of traffic rules to be allowed for ingress"
}
variable "bastion_host_sg_egress" {
  type    = list(any)
  default = []
  description = "The list of traffic rules to be allowed for egress"
}
variable "ec2_ssh_public_key" {
  type = string
  description = "The external generated ssh public key to configure with bastion host"
  sensitive = true
}
variable "security_groups" {
  type =map(any)
  description = "The list of security groups and its traffic definition for the environment"
  default = {}
}
variable "bastion_sg_ingress" {
  type = list
  description = "The list of ingress traffic rules of the bastion host security group"
}
variable "bastion_sg_egress" {
  type =list
  description = "The list of egress traffic rules of the bastion host security group"
}
variable "domain_info" {
  type = map(any)
  description = "The name of the domain registered within aws-route53 or outside"
  default = {}
}
variable "cluster_endpoint_private_access" {
  type        = bool
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  default     = true
}
variable "cluster_create_endpoint_private_access_sg_rule" {
  type        = bool
  description = "Whether to create security group rules for the access to the Amazon EKS private API server endpoint"
  default     = false
}
variable "cluster_endpoint_private_access_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks which can access the Amazon EKS private API server endpoint"
  default     = null
}
variable "cluster_endpoint_public_access" {
  type        = bool
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  default     = false
}

variable "cluster_endpoint_public_access_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  default     = null
}
variable "create_eks" {
  type        = bool
  description = "Controls if EKS resources should be created (it affects almost all resources)"
  default     = true
}
variable "cluster_create_timeout" {
  description = "Timeout value when creating the EKS cluster."
  type        = string
  default     = "30m"
}
variable "manage_aws_auth" {
  type        = bool
  description = "Whether to apply the aws-auth configmap file."
  default     = true
}
variable "wait_for_cluster_timeout" {
  description = "A timeout (in seconds) to wait for cluster to be available."
  type        = number
  default     = 3600
}
variable "enable_irsa" {
  default     = true
  description = "Enables the OpenID Connect Provider for EKS to use IAM Roles for Service Accounts (IRSA)"
  type        = bool
}
variable "write_kubeconfig" {
  default     = true
  description = "Whether to write a Kubectl config file containing the cluster configuration. Saved to variable \"kubeconfig_output_path\"."
  type        = bool
}
variable "attach_worker_cni_policy" {
  description = "Whether to attach the Amazon managed `AmazonEKS_CNI_Policy` IAM policy to the default worker IAM role. WARNING: If set `false` the permissions must be assigned to the `aws-node` DaemonSet pods via another method or nodes will not be able to join the cluster."
  type        = bool
  default     = true
}
variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "public"
}
variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "private"
}
variable "intra_subnet_suffix" {
  description = "Suffix to append to intra subnets name"
  type        = string
  default     = "intra"
}
variable "wg_asg_min_size" {
  description = "The worker group min auto scaling size"
}
variable "wg_asg_max_size" {
  description = "The worker group max auto scaling size"
}
variable "wg_asg_desired_capacity" {
  description = "The worker group desired instance capacity"
}
#dummy variable remove
variable "project_name" {
  description = "The project name"
}
variable "wg_ebs_optimized" {
  description = "The worker group ebs volume optimized"
}
variable "wg_instance_refresh_enabled" {
  description = "The worker group instance refresh status"
}
variable "eks_cluster_logs" {
  description = "List EKS Cluster logs that when logs enabled"
  type        = list(string)
  default     = []
}
variable "app_eks_sg" {
  description = "Security Group for EKS"
}
variable "dhcp_options_domain_name_servers" {
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}
variable "enable_dhcp_options" {
  description = "Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type"
  type        = bool
  default     = true
}
variable "enable_ipv6" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block."
  type        = bool
  default     = false
}
variable "manage_default_network_acl" {
  description = "Should be true to adopt and manage Default Network ACL"
  type        = bool
  default     = false
}
variable "manage_default_route_table" {
  description = "Should be true to manage default route table"
  type        = bool
  default     = false
}
variable "public_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for public subnets"
  type        = bool
  default     = false
}
variable "private_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for private subnets"
  type        = bool
  default     = false
}
variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}
variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}
variable "one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`."
  type        = bool
  default     = false
}
variable "create_igw" {
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them."
  type        = bool
  default     = true
}
variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = false
}
variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}
variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}
variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}
variable "eks_wg_public_ip" {
  description = "Whether to enable pubic IP address for worker groups"
}
variable "eks_wg_root_vol_encrypted" {
  description = "Whether to enable encryption for root volume"
}
variable "eks_wg_root_volume_size" {
  description = "Size of root volume"
}
variable "eks_wg_root_volume_type" {
  description = "Type of root volume"
}
variable "eks_wg_block_device_name" {
  description = "EBS volume device name"
}
variable "eks_wg_ebs_volume_size" {
  description = "Whether to enable pubic IP address for worker groups"
}
variable "eks_wg_ebs_volume_type" {
  description = "Type of EBS volume"

}
variable "eks_wg_ebs_vol_encrypted" {
  description = "Whether to enable encryption for EBS volume"
}
variable "eks_wg_health_check_type" {
  description = "Type of Health check for worker group"
}
variable "nginx_ingress_enabled" {
  description = "Option whether to enable [nginx ingress controller](https://artifacthub.io/packages/helm/nginx/nginx-ingress)"
  type        = bool
  default     = false
}
variable "nginx_ingress_chart_version" {
  description = "Nginx_ingress [nginx ingress controller chart version](https://hub.helm.sh/charts/stable/nginx-ingress)"
  default     = "1.12.0"
}
variable "nginx_ingress_namespace" {
  description = "nginx-ingress controller namespace"
  default     = "nginx-ingress"
}
####### Kubernetes Dashboard ######
variable "create_namespace" {
  description = "Create namespace by module ? true or false"
  type        = bool
  default     = true
}
variable "namespace" {
  description = "Namespace name"
  type        = string
  default     = "kubernetes-dashboard"
}
variable "tls" {
  description = "TLS Secret name for URL"
  type        = string
}
variable "dashboard_subdomain" {
  type    = string
  default = "kubernetes-dashboard."
}
variable "domain" {
  description = "(Required) Domain for URL"
  type        = string
}
variable "cidr_whitelist" {
  description = "General Whitelist for all URLs"
  type        = string
  default     = "0.0.0.0/0"
}
variable "readonly_user" {
  description = "Enable or disable default read-only access to dashboard"
  default     = true
}
variable "create_admin_token" {
  description = "Create admin token for auth"
  default     = true
}
variable "additional_set" {
  description = "Add additional set for helm kubernetes-dashboard"
  default     = []
}
variable "enable_skip_button" {
  description = "Skip login page for ready-only access"
  type        = bool
  default     = true
}
variable "chart_version" {
  description = "Helm Chart version"
  type        = string
  default     = "4.3.1"
}
#dummy variables will be removed after testing
variable "ec2_sg_ingress" {
}
variable "ec2_sg_egress" {
}