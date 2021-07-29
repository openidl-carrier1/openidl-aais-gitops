###########VPC ENDPOINTS FOR PRIVATE EKS CLUSTER  ###########
/*
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = module.aais_vpc.vpc_id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  tags         = { Name = "${var.project_name}-${var.aws_env}-S3", Type = "endpoint_s3" }
  depends_on = [
    module.aais_vpc,
  ]
}
resource "aws_vpc_endpoint_route_table_association" "private_s3_route" {
  count = length(module.aais_vpc.private_route_table_ids)
  //  count = "2"
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = module.aais_vpc.private_route_table_ids[count.index]
  depends_on = [
    module.aais_vpc,
  ]
}
resource "aws_vpc_endpoint" "ec2" {
  vpc_id              = module.aais_vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ec2"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [module.all_worker_mgmt.security_group_id]
  subnet_ids          = module.aais_vpc.private_subnets
  private_dns_enabled = true
  tags                = { Name = "${var.project_name}-${var.aws_env}-EC2", Type = "endpoint_ec2" }
  depends_on = [
    module.aais_vpc,
  ]
}
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = module.aais_vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [module.all_worker_mgmt.security_group_id]
  subnet_ids          = module.aais_vpc.private_subnets
  private_dns_enabled = true
  tags                = { Name = "${var.project_name}-${var.aws_region}-ECR_DKR", Type = "endpoint_dkr" }
  depends_on = [
    module.aais_vpc,
  ]
}
resource "aws_vpc_endpoint" "elasticloadbalancing" {
  vpc_id              = module.aais_vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.elasticloadbalancing"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [module.all_worker_mgmt.security_group_id]
  subnet_ids          = module.aais_vpc.private_subnets
  private_dns_enabled = true
  tags                = { Name = "${var.project_name}-${var.aws_region}-ELASTICLOADBALANCING", Type = "endpoint_elasticloadbalancing" }
  depends_on = [
    module.aais_vpc,
  ]
}
resource "aws_vpc_endpoint" "autoscaling" {
  vpc_id              = module.aais_vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.autoscaling"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [module.all_worker_mgmt.security_group_id]
  subnet_ids          = module.aais_vpc.private_subnets
  private_dns_enabled = true
  tags                = { Name = "${var.project_name}-${var.aws_region}-AUTOSCALING", Type = "endpoint_autoscaling" }
  depends_on = [
    module.aais_vpc,
  ]
}
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = module.aais_vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [module.all_worker_mgmt.security_group_id]
  subnet_ids          = module.aais_vpc.private_subnets
  private_dns_enabled = true
  tags                = { Name = "${var.project_name}-${var.aws_region}-LOGS", Type = "endpoint_logs" }
  depends_on = [
    module.aais_vpc,
  ]
}
resource "aws_vpc_endpoint" "sts" {
  vpc_id              = module.aais_vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.sts"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [module.all_worker_mgmt.security_group_id]
  subnet_ids          = module.aais_vpc.private_subnets
  private_dns_enabled = true
  tags                = { Name = "${var.project_name}-${var.aws_env}-STS", Type = "endpoint_sts" }
  depends_on = [
    module.aais_vpc,
  ]
}
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = module.aais_vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [module.all_worker_mgmt.security_group_id]
  subnet_ids          = module.aais_vpc.private_subnets
  private_dns_enabled = true
  tags                = { Name = "${var.project_name}-${var.aws_env}-ECR_API", Type = "endpoint_api" }
  depends_on = [
    module.aais_vpc,
  ]
}
resource "aws_vpc_endpoint" "app_mesh" {
  vpc_id              = module.aais_vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.appmesh-envoy-management"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [module.all_worker_mgmt.security_group_id]
  subnet_ids          = module.aais_vpc.private_subnets
  private_dns_enabled = true
  tags                = { Name = "${var.project_name}-${var.aws_env}-ECR_API", Type = "endpoint_api" }
  depends_on = [
    module.aais_vpc,
  ]
}
*/
