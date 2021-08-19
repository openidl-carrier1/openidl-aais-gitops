node_type = "aais" #set to aais|carr|anlt
aws_env = "dev" #set to dev|test|prod

#--------------------------------------------------------------------------------------------------------------------
#Application cluster VPC specifications
app_vpc_cidr           = "172.16.0.0/16"
app_availability_zones = ["us-east-2a", "us-east-2b"]
app_public_subnets     = ["172.16.1.0/24", "172.16.2.0/24"]
app_private_subnets    = ["172.16.3.0/24", "172.16.4.0/24"]

#-------------------------------------------------------------------------------------------------------------------
#Blockchain cluster VPC specifications
blk_vpc_cidr           = "172.17.0.0/16"
blk_availability_zones = ["us-east-2a", "us-east-2b"]
blk_public_subnets     = ["172.17.1.0/24", "172.17.2.0/24"]
blk_private_subnets    = ["172.17.3.0/24", "172.17.4.0/24"]

#--------------------------------------------------------------------------------------------------------------------
#Bastion host specifications
/*bastion hosts are placed behind nlb. These NLBs can be configured to be private | public to serve SSH.
In any case whether the endpoint is private|public for an nlb, the source ip_address|cidr_block should be enabled
in bastion hosts security group for ssh traffic
*/
bastion_host_nlb_external = "true"

#application cluster bastion host specifications
app_bastion_sg_ingress =  [{rule="ssh-tcp", cidr_blocks = "172.16.0.0/16"}]
app_bastion_sg_egress =   [
  {rule="https-443-tcp", cidr_blocks = "0.0.0.0/0"},
  {rule="http-80-tcp", cidr_blocks = "0.0.0.0/0"},
  {rule="ssh-tcp", cidr_blocks = "172.16.0.0/16"}] #additional ip_address|cidr_block should be included for ssh

#blockchain cluster bastion host specifications
#bastion host security specifications
blk_bastion_sg_ingress =  [{rule="ssh-tcp", cidr_blocks = "172.17.0.0/16"},]
blk_bastion_sg_egress = [
  {rule="https-443-tcp", cidr_blocks = "0.0.0.0/0"},
  {rule="http-80-tcp", cidr_blocks = "0.0.0.0/0"},
  {rule="ssh-tcp", cidr_blocks = "172.17.0.0/16"}] #additional ip_address|cidr_block should be included for ssh

#--------------------------------------------------------------------------------------------------------------------
#Route53 (PUBLIC) DNS domain related specifications (domain registrar: aws|others, registered: yes|no)
domain_info = {
  domain_registrar = "others", # alternate option: aws
  domain_name = "aaisdirect.com", #primary domain registered
  registered = "yes" #registered already: yes, otherwise: no
  app_sub_domain_name = "dev-openidl" , #subdomain mapped to app eks nlb
  blk_sub_domain_names = ["orderer0","orderer1","aais-peer", "aais-ca"] #list of subdomain names mapped to blk eks nlb
  comments = "aais node public name resolutions"
}

#Route53 (PRIVATE) DNS resolution related specifications
#internal name resolution required for blockchain vpc NLB
internal_domain = "internal.aaisdirect.com" #internal domain name for internal name resolution within vpcs
internal_subdomain = ["orderer0", "orderer1", "aais-peer", "aais-ca"] #list of subdomains for internal resolution within vpcs

#-------------------------------------------------------------------------------------------------------------------
#Transit gateway  specifications
tgw_amazon_side_asn = "64532" #default is 64532.
# routes from application cluster private subnets to other vpc private subnet cidrs (TGW route table updates)
app_tgw_routes = [{destination_cidr_block = "172.17.0.0/16"}]

#routes from blockchain cluster private subnets to other vpc private subnet cidrs (TGW route table updates)
blk_tgw_routes = [{destination_cidr_block = "172.16.0.0/16"}]

#routes from application cluster private subnets to other vpc private subnet cidrs (subnet route table updates)
app_tgw_destination_cidr = ["172.17.0.0/16"]

#routes from blockchain cluster private subnets to other vpc private subnet cidrs (subnet route table updates)
blk_tgw_destination_cidr = ["172.16.0.0/16"]

#--------------------------------------------------------------------------------------------------------------------
#Cognito specifications
userpool_name                = "openidl-pool"
client_app_name              = "openidl-client"
client_callback_urls         = ["https://dev-openidl.aaisdirect.com/callback", "https://dev-openidl.aaisdirect.com/redirect"]
client_default_redirect_url  = "https://dev-openidl.aaisdirect.com/redirect"
client_logout_urls           = ["https://dev-openidl.aaisdirect.com/signout"]
cognito_domain               = "aaisdirect"
email_sending_account        = "COGNITO_DEFAULT" #alternate input is "DEVELOPER". This uses SES service.
# when set to DEVELOPER, please ensure ses_email_identity and userpool_email_source_arn are setup as secrets in github

#--------------------------------------------------------------------------------------------------------------------
#application specific traffic to be allowed in app cluster worker nodes
app_eks_workers_app_sg_ingress = [
  {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "inbound https traffic"
    cidr_blocks = "172.16.0.0/16"
  },
   {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "inbound https traffic"
    cidr_blocks = "172.17.0.0/16"
}]
app_eks_workers_app_sg_egress = [{rule = "all-all"}]

#application specific traffic to be allowed in blk cluster worker nodes
blk_eks_workers_app_sg_ingress = [
  {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "inbound https traffic"
    cidr_blocks = "172.17.0.0/16"
  },
   {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "inbound https traffic"
    cidr_blocks = "172.16.0.0/16"
}]
blk_eks_workers_app_sg_egress = [{rule = "all-all"}]

#--------------------------------------------------------------------------------------------------------------------
# application cluster EKS specifications
app_cluster_name              = "app-cluster"
app_cluster_version           = "1.19"
app_cluster_service_ipv4_cidr = "172.20.0.0/16"

#--------------------------------------------------------------------------------------------------------------------
# blockchain cluster EKS specifications
blk_cluster_name              = "blk-cluster"
blk_cluster_version           = "1.19"
blk_cluster_service_ipv4_cidr = "172.21.0.0/16"

#--------------------------------------------------------------------------------------------------------------------
#cloudtrail related
cw_logs_retention_period = 90
s3_bucket_name_cloudtrail = "cloudtrail-us-east-2"
