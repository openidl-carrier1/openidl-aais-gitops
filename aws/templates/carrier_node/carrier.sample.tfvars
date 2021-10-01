#set org name as below
#when nodetype is aais set org_name="aais"
#when nodetype is analytics set org_name="analytics"
#when nodetype is aais's dummy carrier set org_name="carrier" and for other carriers refer to next line.
#when nodetype is other carrier set org_name="<carrier_org_name>" , example: org_name = "travelers" etc.,

org_name = "trv" # For aais set to aais, for analytics set to analytics, for carriers set their org name, ex: travelers
aws_env = "dev" #set to dev|test|prod
#--------------------------------------------------------------------------------------------------------------------
#Application cluster VPC specifications
app_vpc_cidr           = "172.26.0.0/16"
app_availability_zones = ["us-west-2a", "us-west-2b"]
app_public_subnets     = ["172.26.1.0/24", "172.26.2.0/24"]
app_private_subnets    = ["172.26.3.0/24", "172.26.4.0/24"]

#-------------------------------------------------------------------------------------------------------------------
#Blockchain cluster VPC specifications
blk_vpc_cidr           = "172.27.0.0/16"
blk_availability_zones = ["us-west-2a", "us-west-2b"]
blk_public_subnets     = ["172.27.1.0/24", "172.27.2.0/24"]
blk_private_subnets    = ["172.27.3.0/24", "172.27.4.0/24"]

#--------------------------------------------------------------------------------------------------------------------
#Bastion host specifications
#bastion hosts are placed behind nlb. These NLBs can be configured to be private | public to serve SSH.
#In any case whether the endpoint is private|public for an nlb, the source ip_address|cidr_block should be enabled
#in bastion hosts security group for ssh traffic

bastion_host_nlb_external = "true"

#application cluster bastion host specifications
app_bastion_sg_ingress =  [
  {rule="ssh-tcp", cidr_blocks = "172.26.0.0/16"},
  {rule="ssh-tcp", cidr_blocks = "3.237.88.84/32"}]
app_bastion_sg_egress  =   [
  {rule="https-443-tcp", cidr_blocks = "0.0.0.0/0"},
  {rule="http-80-tcp", cidr_blocks = "0.0.0.0/0"},
  {rule="ssh-tcp", cidr_blocks = "172.26.0.0/16"}] #additional ip_address|cidr_block should be included for ssh

#blockchain cluster bastion host specifications
#bastion host security specifications
blk_bastion_sg_ingress =  [
  {rule="ssh-tcp", cidr_blocks = "172.27.0.0/16"},
  {rule="ssh-tcp", cidr_blocks = "3.237.88.84/32"}]
blk_bastion_sg_egress  = [
  {rule="https-443-tcp", cidr_blocks = "0.0.0.0/0"},
  {rule="http-80-tcp", cidr_blocks = "0.0.0.0/0"},
  {rule="ssh-tcp", cidr_blocks = "172.27.0.0/16"}] #additional ip_address|cidr_block should be included for ssh

#--------------------------------------------------------------------------------------------------------------------
#Route53 (PUBLIC) DNS domain related specifications
domain_info = {
  r53_public_hosted_zone_required = "yes",  #options: yes | no
  domain_name = "travelersdemo.com", #primary domain registered
  sub_domain_name = "trv", #subdomain name
  comments = "travelers node dns name resolutions"
}
#-------------------------------------------------------------------------------------------------------------------
#Transit gateway  specifications
tgw_amazon_side_asn = "64532" #default is 64532

#--------------------------------------------------------------------------------------------------------------------
#Cognito specifications
userpool_name                = "openidl"
client_app_name              = "openidl-client"
client_callback_urls         = ["https://openidl.dev.trv.travelersdemo.com/callback", "https://openidl.dev.trv.travelersdemo.com/redirect"]
client_default_redirect_url  = "https://openidl.dev.trv.travelersdemo.com/redirect"
client_logout_urls           = ["https://openidl.dev.trv.travelersdemo.com/signout"]
cognito_domain               = "travelersdemo" #unique domain name
email_sending_account        = "COGNITO_DEFAULT" # Options: COGNITO_DEFAULT | DEVELOPER
# COGNITO_DEFAULT - Uses cognito default and SES related inputs goes to empty in git secrets
# DEVELOPER - Ensure inputs ses_email_identity and userpool_email_source_arn are setup in git secrets
#--------------------------------------------------------------------------------------------------------------------
#Any additional application specific traffic to be allowed in app_vpc
app_eks_workers_app_sg_ingress = [
   {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "inbound https traffic"
    cidr_blocks = "172.27.0.0/16"
  },
  {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "inbound https traffic"
    cidr_blocks = "172.26.0.0/16"
  }]
app_eks_workers_app_sg_egress = [{rule = "all-all"}]

#Any additional application specific traffic to be allowed in blk_vpc
blk_eks_workers_app_sg_ingress = [
  {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "inbound https traffic"
    cidr_blocks = "172.27.0.0/16"
  },
   {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "inbound https traffic"
    cidr_blocks = "172.26.0.0/16"
  }]
blk_eks_workers_app_sg_egress = [{rule = "all-all"}]

#--------------------------------------------------------------------------------------------------------------------
# application cluster EKS specifications
app_cluster_name              = "app-cluster"
app_cluster_version           = "1.20"

#--------------------------------------------------------------------------------------------------------------------
# blockchain cluster EKS specifications
blk_cluster_name              = "blk-cluster"
blk_cluster_version           = "1.20"

#--------------------------------------------------------------------------------------------------------------------
#cloudtrail related
cw_logs_retention_period = 90
s3_bucket_name_cloudtrail = "cloudtrail-logs"

#--------------------------------------------------------------------------------------------------------------------
#Setting a random value to this variable will rotate password in AWS secret manager which may further required to update in VAULT instance
vault_password_reset = "set" #set a random string to this variable when password required to reset

#--------------------------------------------------------------------------------------------------------------------
#Name of the S3 bucket managing terraform state files
terraform_state_s3_bucket_name = "trv-dev-tfstate-mgmt"
