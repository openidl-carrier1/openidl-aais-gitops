# openidl-aais-gitops

Refer to tf_backend_setup/README.md to setup terraform backend resources

Prerequisites:
    1) Terraform version: >= 1.0.0
    2) AWS provider version: >= 3.0
    3) Kubernetes provider version: >= 1.9
    
Add on prerequisites: 
    1) S3 backend, Dynamodb table
    2) Iam user 
    3) Iam role 
    4) SSH keys for bastion host
    5) SSH keys for eks worker nodes 
    6) Email id configured in aws ses to use as an identity in aws cogntio
    7) Email identity arn configured in ses that is used by aws cognito 
    8) List of iam users will have access to aws eks
    9) List of iam roles will have access to aws eks 

Steps:    
1. Ensure that the aws iam user and iam role created during backend configuration are ready
2. Setup the following sensitive data via git secrets, Prefix: dev_/test_/prod_ according to environment
Note: The pipeline uses individual secrets for each environment and they prefixed as mentioned

List of sensitive data to configure in git secrets

1. prefix_aws_access_key
2. prefix_aws_secret_key
3. prefix_aws_env # ex: dev/test/prod
4. prefix_aws_region # ex: us-east-1
5. prefix_aws_external_id # ex: terraform
6. prefix_aws_user_arn
7. prefix_aws_role_arn
8. prefix_aws_account_number
9. prefix_app_bastion_ssh_key
10. prefix_blk_bastion_ssh_key
11. prefix_app_eks_worker_nodes_ssh_key
12. prefix_blk_eks_worker_nodes_ssh_key
13. prefix_ses_email_identity # ses email identity
14. prefix_userpool_email_source_arn # ses email identity arn
15. prefix_app_cluster_map_users
16. prefix_blk_cluster_map_users
17. prefix_app_cluster_map_roles
18. prefix_blk_cluster_map_roles 

example: dev_aws_access_key, dev_aws_secret_key etc., 

3. Prepare input file for the specific environment as below. 
    dev: inputs/dev/inputs.tfvars
    test: inputs/test/inputs.tfvars
    prod: inputs/prod/inputs.tfvars
   
   


   


   
