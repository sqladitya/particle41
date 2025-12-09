# Remote Backend Configuration (Optional - Extra Credit)
# 
# Uncomment to use remote state with S3 and DynamoDB:
#
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "simpletimeservice/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-state-lock"
#     encrypt        = true
#   }
# }
