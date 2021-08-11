#The following inputs should be via git secrets as they contain sensitive data
aws_core_account_number = ""
aws_secondary_account_number = ["",] #list of aws accounts to share transit gateway with.
aws_access_key = ""
aws_secret_key = ""
aws_user_arn = ""
aws_role_arn = ""
aws_region = ""
aws_external_id = ""
aws_env = "" #(dev,test, prod)
app_bastion_ssh_key = ""
blk_bastion_ssh_key = ""
app_eks_worker_nodes_ssh_key = ""
blk_eks_worker_nodes_ssh_key = ""
tgw_ram_resource_share_id = "" #applicable only for carrier nodes
ses_email_identity = ""
userpool_email_source_arn =""
app_cluster_map_users = ["<userarn>","<userarn>"]
app_cluster_map_roles = ["<rolearn>","<rolearn>"]
blk_cluster_map_users = ["<userarn>","<userarn>"]
blk_cluster_map_roles = ["<rolearn>","<rolearn>"]
#end of sensitive data that goes to git secrets

#set to true when multiple aws accounts are being used. This is required to share/connect using transit gateway
aais = true #when carrier nodes set to false
other_aws_account = true #this is to activate transit gateway sharing to other accounts.
other_aws_region = false

#application name
application_name = "openidl"
#--------------------------------------------------------------------------------------------------------------------

#Application cluster VPC specifications
app_vpc_cidr           = "10.10.0.0/16"
app_availability_zones = ["us-west-2a", "us-west-2b"]
app_public_subnets     = ["10.10.1.0/24", "10.10.2.0/24"]
app_private_subnets    = ["10.10.3.0/24", "10.10.4.0/24"]

#VPC Network ACL traffic rules to be configured in the VPC
#you may need to update these rules as when new networks are added
app_public_nacl_rules = {
  inbound = [{
    rule_number = 100
    rule_action = "allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0" #change this is 172.x cidr of VPC peer(open VPN)
    },
    {
    rule_number = 101
    rule_action = "allow"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 102
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
  },
  {
    rule_number = 103
    rule_action = "allow"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
    },
  {
    rule_number = 104
    rule_action = "allow"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0" #need to verify, related to EKS
    }],
  outbound = [{
    rule_number = 100
    rule_action = "allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0" #change this is 172.x cidr of VPC peer(open VPN)
    },
    {
    rule_number = 101
    rule_action = "allow"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
    },
    {
    rule_number = 102
    rule_action = "allow"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 103
      rule_action = "allow"
      from_port   = 32768
      to_port     = 65535
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
  },
  {
    rule_number = 104
    rule_action = "allow"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0" #need to verify, related to EKS
    }]
}
app_private_nacl_rules = {
  inbound = [{
    rule_number = 100
    rule_action = "allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = "10.10.0.0/16"
    },
    {
    rule_number = 101
    rule_action = "allow"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_block  = "10.10.0.0/16"
    },
    {
    rule_number = 102
    rule_action = "allow"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_block  = "10.10.0.0/16"
    },
    {
      rule_number = 103
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
  {
    rule_number = 104
    rule_action = "allow"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0" #need to verify, related to EKS
    },
  {
    rule_number = 105
    rule_action = "allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = "10.20.0.0/16"
    }],
  outbound = [{
    rule_number = 100
    rule_action = "allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = "10.10.0.0/16"
    },
    {
      rule_number = 101
      rule_action = "allow"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 102
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 103
      rule_action = "allow"
      from_port   = 32768
      to_port     = 65535
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
  {
    rule_number = 104
    rule_action = "allow"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0" #need to verify, related to EKS
    },
   {
    rule_number = 105
    rule_action = "allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = "10.20.0.0/16"
    }]
}
#-------------------------------------------------------------------------------------------------------------------

#Blockchain cluster VPC specifications
blk_vpc_cidr           = "10.20.0.0/16"
blk_availability_zones = ["us-west-2a", "us-west-2b"]
blk_public_subnets     = ["10.20.1.0/24", "10.20.2.0/24"]
blk_private_subnets    = ["10.20.3.0/24", "10.20.4.0/24"]

#VPC Network ACL traffic rules to be configured in the VPC
#you may need to update these rules as when new networks are added
blk_public_nacl_rules = {
  inbound = [{
    rule_number = 100
    rule_action = "allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0" #change this is 172.x cidr of VPC peer(open VPN)
    },
    {
    rule_number = 101
    rule_action = "allow"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 102
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
  },
  {
    rule_number = 103
    rule_action = "allow"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
    },
  {
    rule_number = 104
    rule_action = "allow"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0" #need to verify, related to EKS
    }],
  outbound = [{
    rule_number = 100
    rule_action = "allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0" #change this is 172.x cidr of VPC peer(open VPN)
    },
    {
    rule_number = 101
    rule_action = "allow"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
    },
    {
    rule_number = 102
    rule_action = "allow"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 103
      rule_action = "allow"
      from_port   = 32768
      to_port     = 65535
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
  },
  {
    rule_number = 104
    rule_action = "allow"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0" #need to verify, related to EKS
    }]
}
blk_private_nacl_rules = {
  inbound = [{
    rule_number = 100
    rule_action = "allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = "10.20.0.0/16"
    }, {
    rule_number = 101
    rule_action = "allow"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_block  = "10.20.0.0/16"
    },
    {
    rule_number = 102
    rule_action = "allow"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_block  = "10.20.0.0/16"
    },
    {
      rule_number = 103
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
  {
    rule_number = 104
    rule_action = "allow"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0" #need to verify, related to EKS
    },
  {
    rule_number = 105
    rule_action = "allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = "10.20.0.0/16" #need to verify, related to EKS
    }],
  outbound = [{
    rule_number = 100
    rule_action = "allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = "10.10.0.0/16"
    },
    {
      rule_number = 101
      rule_action = "allow"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 102
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 103
      rule_action = "allow"
      from_port   = 32768
      to_port     = 65535
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
  {
    rule_number = 104
    rule_action = "allow"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0" #need to verify, related to EKS
    },
  {
    rule_number = 105
    rule_action = "allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = "10.10.0.0/16"
    }]
}
#--------------------------------------------------------------------------------------------------------------------

#Default security group assigned/used when a resource is created without any security group attached
default_sg_rules = {
  ingress = [{
    cidr_blocks = "172.16.0.0/16" #update to aais vpc peer ip(openvpn)
    description = "Inbound SSH traffic"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
  }],
  egress = [{
    cidr_blocks = "0.0.0.0/0"
    description = "Outbound SSH traffic"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
  },
  {
    cidr_blocks = "0.0.0.0/0"
    description = "Outbound SSH traffic"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
  }]
}
#--------------------------------------------------------------------------------------------------------------------

#Bastion host specifications
#application cluster bastion host specifications
app_bastion_sg_ingress =  [{rule="ssh-tcp", cidr_blocks = "0.0.0.0/0"},]
app_bastion_sg_egress =   [{rule="https-443-tcp", cidr_blocks = "0.0.0.0/0"},
                       {rule="http-80-tcp", cidr_blocks = "0.0.0.0/0"},
                       {rule="ssh-tcp", cidr_blocks = "10.10.0.0/16"}]

#blockchain cluster bastion host specifications
#bastion host security specifications
blk_bastion_sg_ingress =  [{rule="ssh-tcp", cidr_blocks = "0.0.0.0/0"},]
blk_bastion_sg_egress =   [{rule="https-443-tcp", cidr_blocks = "0.0.0.0/0"},
                       {rule="http-80-tcp", cidr_blocks = "0.0.0.0/0"},
                       {rule="ssh-tcp", cidr_blocks = "10.20.0.0/16"}]

#--------------------------------------------------------------------------------------------------------------------

#Route53 (PUBLIC) DNS domain related specifications (domain registrar: aws/others, registered: yes/no)
domain_info = {
  domain_registrar = "others", # alternate: others
  domain_name: "aaisdirect.com", #primary domain registered
  registered = "yes" #alternate: no
  sub_domain_name: "dev-openidl", #subdomain
  comments: "the aais open idl domain name resolution for app"
}
#Route53 (PRIVATE) DNS resolution related specifications
internal_domain = "internal.aaisdirect.com"
internal_subdomain = ["orderer0", "orderer1", "orderer2", "aais.peer", "aais.ca"]
internal_dns_other_account_vpc_to_authorize = [
  {vpc_region = "us-west-1", vpc_id = "vpc-18acb17f"},
  {vpc_region = "ap-northeast-1", vpc_id = "vpc-2be6df4c"}]
other_acc_zone_ids = ["Z0160046JEYT6MYE5H3I"]
#-------------------------------------------------------------------------------------------------------------------

#Transit gateway  specifications
tgw_amazon_side_asn = "64532"
# routes from application cluster private subnets to other vpc private subnet cidrs (TGW route table updates)
app_tgw_routes = [{
  destination_cidr_block = "0.0.0.0/0"
  blackhole              = true #blackhole = true drops traffic for that destination cidr block
  },
  {destination_cidr_block = "10.20.0.0/16"}, {destination_cidr_block = "10.40.0.0/16"}]

#routes from blockchain cluster private subnets to other vpc private subnet cidrs (TGW route table updates)
blk_tgw_routes = [{destination_cidr_block = "10.10.0.0/16"}, {destination_cidr_block = "10.30.0.0/16"}]

#routes from application cluster private subnets to other vpc private subnet cidrs (subnet route table updates)
app_tgw_destination_cidr = ["10.20.0.0/16", "10.30.0.0/16",  "10.40.0.0/16"]

#routes from blockchain cluster private subnets to other vpc private subnet cidrs (subnet route table updates)
blk_tgw_destination_cidr = ["10.10.0.0/16", "10.30.0.0/16", "10.40.0.0/16"]

#transit gateway id is required when setting up carrier nodes in another aws account
transit_gateway_id = ""
#--------------------------------------------------------------------------------------------------------------------

#Cognito specifications
userpool_name                = "aais-openidl-userpool"
client_app_name              = "aais-openidl-DEMO"
client_callback_urls         = ["https://dev-aais-openidl.aaisdirect.com/callback", "https://dev-aais-openidl.aaisdirect.com/home"]
client_default_redirect_url  = "https://dev-aais-openidl.aaisdirect.com/home"
client_logout_urls           = ["https://dev-aais-openidl.aaisdirect.com/logut"]
cognito_domain               = "dev-aais-openidl-aaisdirect"
#acm_cert_arn                = "" #used for custom domain
#--------------------------------------------------------------------------------------------------------------------

#traffic rules to be opened for the internal application load balancer in the blockchain cluster
blk_eks_alb_sg_ingress = [{
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "inbound traffic to internal elb in blockchain cluster"
      cidr_blocks = "10.10.0.0/16"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "inbound traffic to internal elb in blockchain cluster"
      cidr_blocks = "10.20.0.0/16"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "inbound traffic to internal elb in blockchain cluster"
      cidr_blocks = "10.30.0.0/16"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "inbound traffic to internal elb in blockchain cluster"
      cidr_blocks = "10.40.0.0/16"
    }]
blk_eks_alb_sg_egress  = [{
      rule = "all-all"
    }]
#--------------------------------------------------------------------------------------------------------------------

#traffic rules to be opened for the internal application load balancer in the blockchain cluster
blk_eks_nlb_sg_ingress = [{
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "inbound traffic to internal elb in blockchain cluster"
      cidr_blocks = "10.10.0.0/16"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "inbound traffic to internal elb in blockchain cluster"
      cidr_blocks = "10.20.0.0/16"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "inbound traffic to internal elb in blockchain cluster"
      cidr_blocks = "10.30.0.0/16"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "inbound traffic to internal elb in blockchain cluster"
      cidr_blocks = "10.40.0.0/16"
    }]
blk_eks_nlb_sg_egress  = [{
      rule = "all-all"
    }]
#--------------------------------------------------------------------------------------------------------------------

#application specific traffic to be allowed in app cluster worker nodes
app_eks_workers_app_sg_ingress = []
app_eks_workers_app_sg_egress = []

#application specific traffic to be allowed in blk cluster worker nodes
blk_eks_workers_app_sg_ingress = []
blk_eks_workers_app_sg_egress = []
#--------------------------------------------------------------------------------------------------------------------

#S3 bucket specifications
s3_bucket_name = "my-demo-aais-bucket-openidl"
#--------------------------------------------------------------------------------------------------------------------

# application cluster EKS specifications
app_cluster_name              = "application-cluster"
app_cluster_version           = "1.19"
app_cluster_service_ipv4_cidr = "172.16.0.0/16"
#--------------------------------------------------------------------------------------------------------------------

# blockchain cluster EKS specifications
blk_cluster_name              = "blockchain-cluster"
blk_cluster_version           = "1.19"
blk_cluster_service_ipv4_cidr = "172.17.0.0/16"
#--------------------------------------------------------------------------------------------------------------------
