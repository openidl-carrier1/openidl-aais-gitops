/*Default configuration specifications which can be amended when required, anything specific
and vital for deployment are to be passed as aais_clusters_old.tfvars or blockchain_cluster.tfvars
from a specific terraform workspace*/
#-------------------------------------------------------------------------------------------------------------------
#Bastion host configuration
instance_type                 = "t2.micro"
root_block_device_volume_type = "gp2"
root_block_device_volume_size = "40"
#-------------------------------------------------------------------------------------------------------------------
#Cognito default configurations
client_allowed_oauth_flows                       = ["code", "implicit"] #"client_credentials" is an alternate option
client_allowed_oauth_flows_user_pool_client      = true
client_allowed_oauth_scopes                      = ["email", "phone", "profile", "openid"]
client_explicit_auth_flows                       = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
client_generate_secret                           = true
client_read_attributes                           = ["email", "phone_number", "profile", "address"]
client_write_attributes                          = ["address", "profile"]
client_supported_idp                             = ["COGNITO"]
client_prevent_user_existence_errors             = "ENABLED"
client_id_token_validity                         = 1                                             #hour
client_access_token_validity                     = 1                                             #hour
client_refresh_token_validity                    = 5                                             #day
userpool_recovery_mechanisms                     = [{ name : "verified_email", priority : "1" }] #other options 1)verfied_phone_number 2)admin_only
userpool_username_attributes                     = ["email"]
userpool_auto_verified_attributes                = ["email"]
userpool_mfa_configuration                       = "OPTIONAL"
userpool_software_token_mfa_enabled              = true
password_policy_minimum_length                   = 10
password_policy_require_lowercase                = true
password_policy_require_numbers                  = true
password_policy_require_symbols                  = true
password_policy_require_uppercase                = true
password_policy_temporary_password_validity_days = 10
userpool_advanced_security_mode                  = "AUDIT"
userpool_enable_username_case_sensitivity        = false
#userpool_email_verficiation_subject = ""
#userpool_email_verficiation_message = ""
#-------------------------------------------------------------------------------------------------------------------
#EKS cluster specifications
eks_worker_instance_type             = "t3.medium"
kubeconfig_output_path               = "./kubeconfig_file/"
manage_aws_auth                      = true
cluster_endpoint_private_access      = true
cluster_endpoint_public_access       = true
cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
cluster_create_timeout               = "30m"
wait_for_cluster_timeout             = "300"
eks_cluster_logs                     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

#### Worker Groups Variables###
wg_asg_min_size             = "1"
wg_asg_max_size             = "2"
wg_asg_desired_capacity     = "1"
wg_ebs_optimized            = true
wg_instance_refresh_enabled = false
eks_wg_public_ip            = false
eks_wg_root_vol_encrypted   = true
eks_wg_root_volume_size     = "40"
eks_wg_root_volume_type     = "gp2"
eks_wg_block_device_name    = "/dev/sdf"
eks_wg_ebs_volume_size      = 100
eks_wg_ebs_volume_type      = "gp2"
eks_wg_ebs_vol_encrypted    = true
eks_wg_health_check_type    = "EC2"

