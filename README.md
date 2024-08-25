***Terraform Project for Jobberwocky***

- Create a AWS profile with the credentials with the name 'avanture'
- Create manually the S3 bucket for store the terraform.tfstate file
- Create manually a DynamoDB table and set the value of the Partition key with 'LockId'
- Run the next commands:
``` 
export AWS_PROFILE=avanture
terraform init
terraform plan -lock=false
terraform apply -auto-approve
```  

    
    
