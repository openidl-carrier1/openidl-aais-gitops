#set to different node types like aais, carrier, analytics etc. Prefer 4 letter representation only.
#example: aais|carr|anlt etc.,
node_type = "anlt" #set to aais|carr|anlt
aws_env = "dev" #set to dev|test|prod
#--------------------------------------------------------------------------------------------------------------------
#Application cluster VPC specifications
app_vpc_cidr           = "172.22.0.0/16"
app_availability_zones = ["us-east-1a", "us-east-1b"]
app_public_subnets     = ["172.22.1.0/24", "172.22.2.0/24"]
app_private_subnets    = ["172.22.3.0/24", "172.22.4.0/24"]

#-------------------------------------------------------------------------------------------------------------------
#Blockchain cluster VPC specifications
blk_vpc_cidr           = "172.23.0.0/16"
blk_availability_zones = ["us-east-1a", "us-east-1b"]
blk_public_subnets     = ["172.23.1.0/24", "172.23.2.0/24"]
blk_private_subnets    = ["172.23.3.0/24", "172.23.4.0/24"]

#--------------------------------------------------------------------------------------------------------------------
#Bastion host specifications
#bastion hosts are placed behind nlb. These NLBs can be configured to be private | public to serve SSH.
#In any case whether the endpoint is private|public for an nlb, the source ip_address|cidr_block should be enabled
#in bastion hosts security group for ssh traffic

bastion_host_nlb_external = "true"

#application cluster bastion host specifications
app_bastion_sg_ingress =  [{rule="ssh-tcp", cidr_blocks = "172.22.0.0/16"}, {rule="ssh-tcp", cidr_blocks = "3.237.88.84/32"}]
app_bastion_sg_egress  =   [
  {rule="https-443-tcp", cidr_blocks = "0.0.0.0/0"},
  {rule="http-80-tcp", cidr_blocks = "0.0.0.0/0"},
  {rule="ssh-tcp", cidr_blocks = "172.22.0.0/16"}] #additional ip_address|cidr_block should be included for ssh

#blockchain cluster bastion host specifications
#bastion host security specifications
blk_bastion_sg_ingress =  [{rule="ssh-tcp", cidr_blocks = "172.23.0.0/16"}, {rule="ssh-tcp", cidr_blocks = "3.237.88.84/32"}]
blk_bastion_sg_egress  = [
  {rule="https-443-tcp", cidr_blocks = "0.0.0.0/0"},
  {rule="http-80-tcp", cidr_blocks = "0.0.0.0/0"},
  {rule="ssh-tcp", cidr_blocks = "172.23.0.0/16"}] #additional ip_address|cidr_block should be included for ssh

#--------------------------------------------------------------------------------------------------------------------
#Route53 (PUBLIC) DNS domain related specifications (domain registrar: aws|others, registered: yes|no)
domain_info = {
  domain_registrar = "others" #alternate option: aws
  domain_name = "aaisanalyticsdemo.com", #primary domain registered
  registered = "no" #registered already: yes, otherwise: no
  app_sub_domain_name = "openidl-anlaytics" , #subdomain mapped to app eks nlb
  comments = "analytics node name resolutions"
}
#-------------------------------------------------------------------------------------------------------------------
#Transit gateway  specifications
tgw_amazon_side_asn = "64532" #default is 64532.
# routes from application cluster private subnets to other vpc private subnet cidrs (TGW route table updates)
app_tgw_routes = [{destination_cidr_block = "172.23.0.0/16"}]

#routes from blockchain cluster private subnets to other vpc private subnet cidrs (TGW route table updates)
blk_tgw_routes = [{destination_cidr_block = "172.22.0.0/16"}]

#routes from application cluster private subnets to other vpc private subnet cidrs (subnet route table updates)
app_tgw_destination_cidr = ["172.23.0.0/16"]

#routes from blockchain cluster private subnets to other vpc private subnet cidrs (subnet route table updates)
blk_tgw_destination_cidr = ["172.22.0.0/16"]

#--------------------------------------------------------------------------------------------------------------------
#Cognito specifications
userpool_name                = "openidl"
client_app_name              = "openidl-client"
client_callback_urls         = ["https://dev-openidl-analytics.aaisanalyticsdemo.com/callback", "https://dev-openidl-analytics.aaisanalyticsdemo.com/redirect"]
client_default_redirect_url  = "https://dev-openidl-analytics.aaisanalyticsdemo.com/redirect"
client_logout_urls           = ["https://dev-openidl-analytics.aaisanalyticsdemo.com/signout"]
cognito_domain               = "aaisanalyticsdemo" #unique domain name
email_sending_account        = "COGNITO_DEFAULT" # Options: COGNITO_DEFAULT | DEVELOPER
# COGNITO_DEFAULT - Uses cognito default and SES related inputs goes to empty in git secrets
# DEVELOPER - Ensure inputs ses_email_identity and userpool_email_source_arn are setup in git secrets
#--------------------------------------------------------------------------------------------------------------------
#application specific traffic to be allowed in app cluster worker nodes
app_eks_workers_app_sg_ingress = [
  {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "inbound https traffic"
    cidr_blocks = "172.22.0.0/16"
  },
   {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "inbound https traffic"
    cidr_blocks = "172.23.0.0/16"
},
  {
    from_port = 8443
    to_port = 8443
    protocol = "tcp"
    description = "inbound https traffic"
    cidr_blocks = "172.22.0.0/16"
  },
   {
    from_port = 8443
    to_port = 8443
    protocol = "tcp"
    description = "inbound https traffic"
    cidr_blocks = "172.23.0.0/16"
}]
app_eks_workers_app_sg_egress = [{rule = "all-all"}]

#application specific traffic to be allowed in blk cluster worker nodes
blk_eks_workers_app_sg_ingress = [
  {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "inbound https traffic"
    cidr_blocks = "172.22.0.0/16"
  },
   {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "inbound https traffic"
    cidr_blocks = "172.23.0.0/16"
},
  {
    from_port = 8443
    to_port = 8443
    protocol = "tcp"
    description = "inbound https traffic"
    cidr_blocks = "172.22.0.0/16"
  },
   {
    from_port = 8443
    to_port = 8443
    protocol = "tcp"
    description = "inbound https traffic"
    cidr_blocks = "172.23.0.0/16"
}]
blk_eks_workers_app_sg_egress = [{rule = "all-all"}]

#--------------------------------------------------------------------------------------------------------------------
# application cluster EKS specifications
app_cluster_name              = "app-cluster"
app_cluster_version           = "1.20"
app_cluster_service_ipv4_cidr = "172.26.0.0/16"

#--------------------------------------------------------------------------------------------------------------------
# blockchain cluster EKS specifications
blk_cluster_name              = "blk-cluster"
blk_cluster_version           = "1.20"
blk_cluster_service_ipv4_cidr = "172.27.0.0/16"

#--------------------------------------------------------------------------------------------------------------------
#cloudtrail related
cw_logs_retention_period = 90
s3_bucket_name_cloudtrail = "cloudtrail-logs"

