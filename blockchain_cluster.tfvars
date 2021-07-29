#when using github actions the below inputs are set as secrets in github/vault
#when using local terraform workspace, set these inputs in this file
aws_core_account_number = ""
aws_secondary_account_number = ["",""]
aws_user_arn = ""
aws_role_arn = ""
ec2_ssh_public_key = ""

#set to true when multiple aws accounts are being used. This is required to share/connect using transit gateway
other_aws_account = false

#aws account and region specifications
aws_region = "us-west-1"
aws_env    = "dev"

#project, cluster and application type and their name specification
project_name     = "openidl"
application_name = "openidl"
#defines whether this is a application cluster (app_cluster) or blockchain cluster(blockchain_cluster)
cluster_type = "blockchain_cluster"

#VPC specifications
vpc_cidr           = "10.20.0.0/16"
availability_zones = ["us-west-1a", "us-west-1b"]
public_subnets     = ["10.20.1.0/24", "10.20.2.0/24"]
private_subnets    = ["10.20.4.0/24", "10.20.5.0/24"]

#bastion host security specifications
bastion_sg_ingress =  [{rule="ssh-tcp", cidr_blocks = "0.0.0.0/0"},]
bastion_sg_egress =   [{rule="https-443-tcp", cidr_blocks = "0.0.0.0/0"},
                       {rule="http-80-tcp", cidr_blocks = "0.0.0.0/0"},
                       {rule="ssh-tcp", cidr_blocks = "10.20.0.0/16"}]

#default private subnet ec2 configuration used for demo purpose
#you may require to keep updating these rules as and when new network added
ec2_sg_ingress = [{rule="ssh-tcp", cidr_blocks="10.20.0.0/16"},
                  {rule="https-443-tcp", cidr_blocks="10.20.0.0/16"},
                  {rule="http-80-tcp", cidr_blocks="10.20.0.0/16"},
                  {rule="ssh-tcp", cidr_blocks="10.10.0.0/16"}] #added for testing
ec2_sg_egress = [{rule="https-443-tcp", cidr_blocks="0.0.0.0/0"},
                 {rule="http-80-tcp", cidr_blocks="0.0.0.0/0"},]

#default vpc security group, used only when a resource is created without any security group attached
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
#VPC Network ACL traffic rules to be configured in the VPC
#you may need to update these rules as when new networks are added
public_nacl_rules = {
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
private_nacl_rules = {
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

#DNS domain related specifications (domain registrar: aws/others, registered: yes/no)
domain_info = {
  domain_registrar = "others", # alternate: others
  domain_name: "aaisdirect.com", #primary domain registered
  registered = "yes" #alternate: no
  sub_domain_name: "dev-openidl", #subdomain
  comments: "the aais open idl domain name resolution for app"
}
#Transit Gateway related config parameters required for cluster type blockchain_cluster
#tgw_ram_resource_share_id is only required when connecting to tgw of another aws account
#tgw_ram_resource_share_id = ""
transit_gateway_id = "tgw-040eb8b36610f6099"
#transit_gateway_route_table_id = "tgw-rtb-0fcfcb8acf6680948"
#to update vpc subnet route tables to route via tgw for the specific routes
tgw_destination_cidr = ["10.10.0.0/16"]
tgw_routes = [{
  destination_cidr_block = "10.20.0.0/16"
  blackhole              = false
  },
  {
    destination_cidr_block = "0.0.0.0/0"
    blackhole              = true
},]

#EKS Cluster specifications
app_eks_sg                   = "blk_eks_sg"
cluster_version              = "1.19"

#Kubernetes dashboard
create_namespace  = true
namespace  = "kubernetes-dashboard"
dashboard_subdomain = ""
domain = "localhost"
