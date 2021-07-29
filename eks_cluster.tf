/*
provider "kubernetes" {
  config_path            = "./kubeconfig_file/kubeconfig_${local.cluster_name}"
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
module "app_eks" {
  source                                         = "terraform-aws-modules/eks/aws"
  version                                        = "17.1.0"
  create_eks                                     = var.create_eks
  cluster_name                                   = local.cluster_name
  enable_irsa                                    = var.enable_irsa
  cluster_version                                = var.cluster_version
  subnets                                        = module.aais_vpc.private_subnets
  vpc_id                                         = module.aais_vpc.vpc_id
  write_kubeconfig                               = true
  kubeconfig_output_path                         = var.kubeconfig_output_path
  cluster_endpoint_private_access                = var.cluster_endpoint_private_access
  cluster_endpoint_public_access                 = var.cluster_endpoint_public_access
  cluster_create_endpoint_private_access_sg_rule = var.cluster_create_endpoint_private_access_sg_rule
  cluster_endpoint_private_access_cidrs          = var.cluster_endpoint_private_access_cidrs
  cluster_endpoint_public_access_cidrs           = var.cluster_endpoint_public_access_cidrs
  cluster_create_timeout                         = var.cluster_create_timeout
  wait_for_cluster_timeout                       = var.wait_for_cluster_timeout
  manage_aws_auth                                = var.manage_aws_auth
  cluster_enabled_log_types                      = var.eks_cluster_logs
  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks_kms_key_app.arn
      resources        = ["secrets"]
    }
  ]
  worker_groups = [
    {
      name                          = "${var.eks_worker_name_1}"
      instance_type                 = var.eks_worker_instance_type
      platform                      = "linux"
      additional_userdata           = "echo foo bar"
      asg_min_size                  = var.wg_asg_min_size
      asg_max_size                  = var.wg_asg_max_size
      asg_desired_capacity          = var.wg_asg_desired_capacity
      additional_security_group_ids = module.worker_group_mgmt_one.security_group_id
      public_ip                     = var.eks_wg_public_ip
      root_encrypted                = var.eks_wg_root_vol_encrypted
      //encrypted                     = true
      root_encrypted = true
      additional_ebs_volumes = [
        {
          block_device_name = "${var.eks_wg_block_device_name}",
          volume_size       = "${var.eks_wg_ebs_volume_size}",
          volume_type       = var.eks_wg_ebs_volume_type,
          encrypted         = var.eks_wg_ebs_vol_encrypted
        }
      ]
      root_volume_size         = var.eks_wg_root_volume_size
      root_volume_type         = var.eks_wg_root_volume_type
      key_name                 = module.key_pair_external.key_pair_key_name
      subnet_id                = module.aais_vpc.private_subnets[0]
      target_group_arns        = module.eks_nlb.target_group_arns
      health_check_type        = var.eks_wg_health_check_type
      ebs_optimized            = var.wg_ebs_optimized
      instance_refresh_enabled = var.wg_instance_refresh_enabled
    },
    {
      name                          = "${var.eks_worker_name_2}"
      instance_type                 = var.eks_worker_instance_type
      platform                      = "linux"
      additional_userdata           = "echo foo bar"
      asg_min_size                  = var.wg_asg_min_size
      asg_max_size                  = var.wg_asg_max_size
      asg_desired_capacity          = var.wg_asg_desired_capacity
      additional_security_group_ids = module.worker_group_mgmt_two.security_group_id
      public_ip                     = var.eks_wg_public_ip
      root_encrypted                = var.eks_wg_root_vol_encrypted
      //encrypted                     = true
      additional_ebs_volumes = [
        {
          block_device_name = "${var.eks_wg_block_device_name}",
          volume_size       = "${var.eks_wg_ebs_volume_size}",
          volume_type       = var.eks_wg_ebs_volume_type,
          encrypted         = var.eks_wg_ebs_vol_encrypted
        }
      ]
      root_volume_size         = var.eks_wg_root_volume_size
      root_volume_type         = var.eks_wg_root_volume_type
      key_name                 = module.key_pair_external.key_pair_key_name
      subnet_id                = module.aais_vpc.private_subnets[1]
      target_group_arns        = module.eks_nlb.target_group_arns
      health_check_type        = var.eks_wg_health_check_type
      ebs_optimized            = var.wg_ebs_optimized
      instance_refresh_enabled = var.wg_instance_refresh_enabled
    }
  ]
  worker_additional_security_group_ids = [module.all_worker_mgmt.security_group_id]
  tags = {
    terraform   = "true"
    environment = var.aws_env
  }
  depends_on = [
    module.aais_vpc,
    aws_vpc_endpoint.s3,
    aws_vpc_endpoint_route_table_association.private_s3_route,
    aws_vpc_endpoint.ec2,
    aws_vpc_endpoint.ecr_dkr,
    aws_vpc_endpoint.elasticloadbalancing,
    aws_vpc_endpoint.autoscaling,
    aws_vpc_endpoint.logs,
    aws_vpc_endpoint.sts,
    aws_vpc_endpoint.ecr_api,
    aws_vpc_endpoint.app_mesh,
    aws_iam_role_policy_attachment.app-eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.app-eks-cluster-AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.app-eks-cluster-AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.app-eks-cluster-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.app-eks-cluster-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.app-eks-cluster-AmazonEC2ContainerRegistryReadOnly,
  ]
}
*/
