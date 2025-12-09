# SimpleTimeService - DevOps Challenge

A minimal microservice that returns the current timestamp and visitor's IP address in JSON format, deployed on AWS ECS using Terraform.

## Project Structure

```
.
├── app/                    # Application code and Docker configuration
│   ├── app.py             # Flask web service
│   ├── requirements.txt   # Python dependencies
│   └── Dockerfile         # Container image definition
├── terraform/             # Infrastructure as Code
│   ├── main.tf           # Main Terraform configuration
│   ├── variables.tf      # Variable definitions
│   ├── outputs.tf        # Output definitions
│   └── terraform.tfvars  # Variable values (UPDATE THIS!)
└── README.md             # This file
```

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (version 20.10+)
- [Docker Hub account](https://hub.docker.com/)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform](https://developer.hashicorp.com/terraform/downloads) (version 1.0+)
- AWS account with appropriate permissions

---

## Part 1: Application & Docker

### Build and Test Locally

```bash
cd app
docker build -t simpletimeservice:latest .
docker run -p 8080:8080 simpletimeservice:latest

# Test (in another terminal)
curl http://localhost:8080
```

Expected response:
```json
{
  "timestamp": "2024-01-15T10:30:45.123456Z",
  "ip": "172.17.0.1"
}
```

### Publish to Docker Hub

```bash
docker login
docker tag simpletimeservice:latest YOUR_USERNAME/simpletimeservice:latest
docker push YOUR_USERNAME/simpletimeservice:latest
```

---

## Part 2: Terraform Infrastructure

### Configure AWS Credentials

```bash
aws configure
```
Enter your AWS Access Key ID, Secret Access Key, and region (e.g., `us-east-1`).

### Update Configuration

Edit `terraform/terraform.tfvars` and update the `container_image` variable:
```hcl
container_image = "YOUR_USERNAME/simpletimeservice:latest"
```

### Deploy

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Type `yes` when prompted. Deployment takes ~10 minutes.

### Test Deployment

```bash
# Use the ALB URL from Terraform output
curl http://<alb-dns-name>
```

### Cleanup

**IMPORTANT:** Destroy resources to avoid AWS charges (~$78/month if left running)

```bash
terraform destroy
```

---

## Architecture

- **VPC**: 2 public and 2 private subnets across 2 availability zones
- **ECS Fargate**: 2 tasks running in private subnets
- **Application Load Balancer**: Public-facing ALB in public subnets
- **NAT Gateway**: For private subnet internet access
- **Security Groups**: Properly configured for ALB and ECS communication

---

## Troubleshooting

**Container exits immediately:**
- Check logs: `docker logs <container-id>`

**Terraform authentication errors:**
- Verify credentials: `aws sts get-caller-identity`

**ECS tasks not starting:**
- Verify Docker image is public and accessible
- Check CloudWatch logs: `/ecs/simpletimeservice`
- Wait 2-3 minutes for tasks to fully start

**Application not responding:**
- Wait for ECS tasks to pass health checks
- Check security group rules allow ALB → ECS traffic

---

## Security Features

- ✅ Application runs as non-root user in container
- ✅ ECS tasks deployed in private subnets
- ✅ Security groups follow principle of least privilege
- ✅ No hardcoded credentials
- ✅ CloudWatch logging enabled

---

## Cost Estimate

Running this infrastructure costs approximately **$78/month** (us-east-1):
- NAT Gateway: ~$32/month
- Application Load Balancer: ~$16/month
- ECS Fargate (2 tasks): ~$29/month
- CloudWatch Logs: ~$1/month

**Always run `terraform destroy` when done testing!**

---

## Extra Credit

### Remote Backend (Optional)

Uncomment the backend configuration in `terraform/backend.tf` and create:
```bash
# Create S3 bucket
aws s3 mb s3://your-terraform-state-bucket

# Create DynamoDB table
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

### CI/CD Pipeline (Optional)

GitHub Actions workflow included in `.github/workflows/deploy.yml`. Add these secrets to your repository:
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

---

## Contact

For questions: careers@particle41.com
