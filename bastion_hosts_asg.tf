module "bastion_sg" {
  depends_on = [module.aais_vpc]
  #for_each = {for k,v in local.bastion_sgs : k => v}
  source                  = "terraform-aws-modules/security-group/aws"
  name                    = "${local.stdname}-bastion-host-sg"
  description             = "Security group associated with bastion host"
  vpc_id                  = module.aais_vpc.vpc_id
  tags                    = local.tags
  ingress_with_cidr_blocks = var.bastion_sg_ingress
  egress_with_cidr_blocks = var.bastion_sg_egress
}
module "key_pair_external" {
  depends_on = [module.aais_vpc]
  source = "terraform-aws-modules/key-pair/aws"
  key_name   = "${local.stdname}-${random_pet.this.id}-external"
  public_key = var.ec2_ssh_public_key
  tags = local.tags
}
module "bastion_nlb" {
  depends_on = [data.aws_subnet_ids.aais_vpc_public_subnets, module.aais_vpc]
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"
  name = "${local.stdname}-bastion-host-nlb"
  #name = local.app_bastion_nlb_name
  create_lb = true
  load_balancer_type = "network"
  enable_cross_zone_load_balancing = true
  internal = false
  ip_address_type = "ipv4"
  vpc_id = module.aais_vpc.vpc_id
  subnets = module.aais_vpc.public_subnets
  http_tcp_listeners = [
    {
      port        = 22
      protocol    = "TCP"
      action_type = "forward"
    }
  ]
  target_groups = [
    {
      name_prefix      = "nlb-tg"
      backend_protocol = "TCP"
      backend_port     = 22
      target_type      = "instance"
      preserve_client_ip = true
      tags = { tcp_udp = true }
      health_check = {
        enabled             = true
        interval            = 30
        port                = "22"
        protocol            = "TCP"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        #timeout             = 6
      }
    }
  ]
  tags = local.tags
  lb_tags = local.tags
  idle_timeout = 180
  target_group_tags = local.tags
}
module "bastion_host_asg" {
  depends_on = [module.aais_vpc, module.bastion_sg]
  source = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  name = "${local.stdname}-bastion-host-asg"
  create_lt = true
  create_asg = true

  #auto scaling group specifics
  use_lt = true
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1 #var.aws_env == "prod" ? 2 : 1
  wait_for_capacity_timeout = 0
  default_cooldown = 600
  health_check_type         = "EC2"
  target_group_arns = module.bastion_nlb.target_group_arns
  health_check_grace_period = 300
  vpc_zone_identifier       = module.aais_vpc.public_subnets
  #service_linked_role_arn   = aws_iam_service_linked_role.autoscaling_svc_role.arn
  #launch template specifics
  image_id = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  #iam_instance_profile_arn = aws_iam_instance_profile.bastion_host_profile.arn
  ebs_optimized = false
  enable_monitoring = true
  key_name = module.key_pair_external.key_pair_key_name
  security_groups = [module.bastion_sg.security_group_id]
  instance_initiated_shutdown_behavior = "stop"
  disable_api_termination = false
  placement_tenancy = "default"
  #user_data_base64 = local.bastion_host_userdata
  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      no_device = 0
      ebs = {
        delete_on_termination = true
        encrypted = true
        volume_size = var.root_block_device_volume_size
        volume_type = var.root_block_device_volume_type
      }
    },
    {
      device_name = "/dev/sdh"
      no_device = 1
      ebs = {
        delete_on_termination = true
        encrypted = true
        volume_size = var.ebs_block_device_volume_size
        volume_type = var.ebs_block_device_volume_type
      }
    }
  ]
  tags_as_map = local.tags
}
