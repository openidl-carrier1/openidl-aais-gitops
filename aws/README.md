# openidl-aais-gitops

**Refer to tf_backend_setup/README.md to configure terraform backend resources**

##Prerequisites:
    
    | Resource                        | Version  |
    | Terraform version:              | >= 1.0.0 |
    | AWS provider version:           | >= 3.0   |
    | Kubernetes provider version:    | >= 1.9   |
    
**Additional requirements:** 
    
    1) S3 backend, Dynamodb table
    2) Iam user 
    3) Iam role 
    4) SSH keys for bastion host
    5) SSH keys for eks worker nodes 
    6) Email id configured in aws ses to use as an identity in aws cogntio
    7) Email identity arn configured in ses that is used by aws cognito 
    8) List of iam users will have access to aws eks
    9) List of iam roles will have access to aws eks 
    10) Enable SES service in the configured region to production state by moving out of sandbox. Please refer to documention link below..

https://docs.aws.amazon.com/ses/latest/DeveloperGuide/request-production-access.html

**Steps:**    
1. Ensure that the aws iam user and iam role created during backend configuration are ready
2. Setup branch names as per the node type and environment type. Ex: <node_type>_<env_type> (aais_dev) 
3. Setup github environment as branch name (ex: <node_type>_<env_type>) (aais_dev)
4. Configure required environment protection rules
5. Configure deployment branches pattern as <node_type>_<env_type>* (Ex: aais_dev*)
6. Add all required secrets as environment secrets 
   
Note: The pipeline uses individual secrets for each node type (aais/carrier/analytics) and for each environment (dev/test/prod).

List of sensitive data to configure as secrets under git environment section. 

        1. aws_access_key
        2. aws_secret_key
        3. aws_region # ex: us-east-1
        4. aws_external_id # ex: terraform
        5. aws_user_arn
        6. aws_role_arn
        7. aws_account_number
        8. app_bastion_ssh_key
        9. blk_bastion_ssh_key
        10. app_eks_worker_nodes_ssh_key
        11. blk_eks_worker_nodes_ssh_key
        12. ses_email_identity # ses email identity
        13. userpool_email_source_arn # ses email identity arn
        14. app_cluster_map_users
        15. blk_cluster_map_users
        16. app_cluster_map_roles
        17. blk_cluster_map_roles 

7. Clone the repository 
8. Prepare input file for the specific node and specific environment. 

    |    node_type         |            path                       |    input file      |
    |----------------------|---------------------------------------|--------------------|
    | aais_node/dev        |  aws/data_feed_in/aais_node/dev       |  aais.tfvars       |   
    | aais_node/test       |  aws/data_feed_in/aais_node/test      |  aais.tfvars       |    
    | aais_node/prod       |  aws/data_feed_in/aais_node/prod      |  aais.tfvars       | 
    |                      |                                       |                    | 
    | carrier_node/dev     |  aws/data_feed_in/carrier_node/dev    |  carrier.tfvars    |  
    | carrier_node/test    |  aws/data_feed_in/carrier_node/test   |  carrier.tfvars    |  
    | carrier_node/prod    |  aws/data_feed_in/carrier_node/prod   |  carrier.tfvars    |  
    |                      |                                       |                    |  
    | analytics_node/dev   |  aws/data_feed_in/analytics_node/dev  |  analytics.tfvars  |  
    | analytics_node/test  |  aws/data_feed_in/analytics_node/test |  analytics.tfvars  |  
    | analytics_node/prod  |  aws/data_feed_in/analytics_node/prod |  analytics.tfvars  |  

4. Commit the updates to a feature branch, ensure the name starts with base branch name (ex: for aais_dev, feature branch: aais_dev<*>)
5. Push the feature branch to git repository
6. Submit Pull request and upon review and approve submit merge to successfully get the code updates
7. The pull request will trigger github actions to run terraform plan
8. The merge request will trigger github actions to run terraform apply




   
