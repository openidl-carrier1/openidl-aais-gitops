#Define required providers configuration when using local terraform workspace
/*
provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn     = ""
    session_name = ""
    external_id  = ""

}
*/
#required when used in github actions pipeline
provider "aws" {
  region = var.aws_region
}