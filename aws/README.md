# openidl-aais-gitops

**Refer to aws/tf_backend_setup/README.md to configure terraform backend resources**

##Prerequisites:
    
    |     Resource                    | Version  |
    |---------------------------------|----------|
    | Terraform version:              | >= 1.0.0 |
    | AWS provider version:           | >= 3.0   |
    | Kubernetes provider version:    | >= 1.9   |
    
**Additional requirements:** 
    
    1) S3 backend, Dynamodb table, s3 bucket for inputfile
    2) Iam user 
    3) Iam role 
    4) SSH keys for bastion host
    5) SSH keys for eks worker nodes 
    6) List of IAM users to have aws eks access (if NONE, skip)
    7) List of IAM roles to have aws eks access  (if NONE, skip)
    8) Choose whether Cognito to use COGNITO_DEFAULT | DEVELOPER (SES) for emails
    9) For COGNITO_DEFAULT, set email_sending_account = "COGNITO_DEFAULT" in inputfile
    10) For SES, set email_sending_account = "DEVELOPER" and 
        10.1) Select aws SES service in a region supported by Cognito (us-west-1|us-east-1|us-west-2)
        10.2) Verify a valid email address that would be used from-to, reply-to email id
        10.3) Submit a request to aws support to move the SES service that is preferred to move out of sandbox for production use. Refer to below link 
    https://docs.aws.amazon.com/ses/latest/DeveloperGuide/request-production-access.html
    11) Note down the verified email address in SES and the ARN of the verified email id 

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
        12. ses_email_identity # Required when email_sending_account = "DEVELOPER", otherwise set to empty in git secrets
        13. userpool_email_source_arn # Required when email_sending_account = "DEVELOPER", otherwise set to empty in git secrets
        14. app_cluster_map_users # Required if any IAM user required EKS access, otherwise set to empty in git secrets
        15. blk_cluster_map_users # Required if any IAM user required EKS access, otherwise set to empty in git secrets
        16. app_cluster_map_roles # Required if any IAM role required EKS access, otherwise set to empty in git secrets
        17. blk_cluster_map_roles  # Required if any IAM role required EKS access, otherwise set to empty in git secrets
        18. aws_input_bucket #s3 bucket used to store terraform input file 

7. Clone the repository 
8. Prepare input file for the specific node and specific environment, refer to directory "templates" for reference template.
9. Once input file is prepared, upload to S3 under a relevant directory based on node type and environment type. Example of carrier node for dev, upload to the path as below. 
    Path: S3://<bucket>/carrier_node/dev/carrier.tfvars
 
10. Commit the updates to a feature branch, ensure the name starts with base branch name (ex: for aais_dev, feature branch: aais_dev<*>)
11. Push the feature branch to git repository
12. Submit Pull request and upon review and approve submit merge to successfully get the code updates
13. The pull request will trigger github actions to run terraform plan
14. The merge request will trigger github actions to run terraform apply




   
