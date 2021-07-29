# terraform backend setup 
This code can be cloned to an environment where terraform CLI can be used to initially setup terraform backend resources S3 bucket for managing terraform state files and DynamoDB for handling state file locking. 

1. Setup terraform CLI
2. Get this code to the system
3. Refer to runbook documentation to prepare AWS environment access with IAM user and roles required
4. Input the required details to the code via terraform.tfvars
5. Run the terraform plan and apply 
