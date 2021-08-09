# openidl-aais-gitops

Prerequisites:
    Terraform version: >= 1.0.0
    AWS provider version: >= 3.0
    Kubernetes provider version: >= 1.9
    
Add on prerequisites: 
    S3 backend, Dynamodb table
    Iam user
    Iam role 
    ssh keys for bastion host
    ssh keys for eks worker nodes 
    list of aws secondary account numbers to share transit gateway if applicable 
    transit gateway resource id to connect blockchain cluster vpc if applicable
    email id configured in aws ses to use as an identity in aws cogntio
    email identity arn configured in ses that is used by aws cognito 
    list of iam users will have access to aws eks
    list of iam roles will have access to aws eks 

    
1. Ensure that the aws iam user and iam role created during backend configuration are ready
2. Setup the following sensitive data via git secrets, Prefix dev_/test_/Prod_ according to environment
Note: The pipeline uses individual secrets for each environment and they prefixed as mentioned

List of sensitive data to configure in git secrets

<env>_aws_access_key
<env>_aws_secret_key
<env>_aws_env # ex: dev/test/prod
<env>_aws_region # ex: us-east-1
<env>_aws_external_id # ex: terraform
<env>_aws_user_arn
<env>_aws_role_arn
<env>_aws_core_account_number
<env>_aws_secondary_account_number #acc numbers to share tgw
<env>_app_bastion_ssh_key
<env>_blk_bastion_ssh_key
<env>_app_eks_worker_nodes_ssh_key
<env>_blk_eks_worker_nodes_ssh_key
<env>_tgw_ram_resource_share_id #applicable for carrier nodes
<env>_ses_email_identity # ses email identity
<env>_userpool_email_source_arn # ses email identity arn
<env>_app_cluster_map_users
<env>_blk_cluster_map_users
<env>_app_cluster_map_roles
<env>_blk_cluster_map_roles 

example: dev_aws_access_key, dev_aws_secret_key etc., 

3. Prepare input file for the specific environment as below. 
    dev: inputs/dev/env_inputs.tfvars
    test: inputs/test/env_inputs.tfvars
    prod: inputs/prod/env_inputs.tfvars
   
4. To prepare the input file refer to templates according to usecase scenario 
    Usecase1: aais base environment.
            aais_clusters.tfvars.template
   
    Usecase2: carriers in same aws account of aais base environment.
            aais_carriers_same_account.tfvars.template 
   
    Usecase3: carriers in another aws account in same region of base aais environment. 
            carriers_another_account_same_region.tfvars.template 
   
    Usecase3: carriers in another aws account and another aws region than base aais environment. 
            carriers_another_account_another_region.tfvars.template
   


   


   
