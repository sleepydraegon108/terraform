# Static Website Deployment with Terraform

This repository demonstrates the deployment of a static website using AWS services (S3 and CloudFront) with Terraform. The project includes an automated pipeline to ensure infrastructure code quality and successful deployment.

## Project Overview

This project provisions the following resources:

1. **Static Website**:
   - A simple `index.html` file containing the content:
     ```html
     <HTML>
     <BODY> 
     Hello World! 
     </BODY> 
     </HTML>
     ```

2. **AWS Resources**:
   - An **S3 bucket** to store the static website. Public access is disabled for security.
   - A **CloudFront distribution** to serve the website efficiently and securely.

3. **CI/CD Pipeline**:
   - Automates the following Terraform commands:
     - `terraform init`: Initializes the Terraform environment.
     - `terraform fmt -check`: Ensures the code adheres to formatting standards.
     - `terraform validate`: Verifies the correctness of the Terraform configuration.

## Prerequisites

- Terraform installed on your local system.
- An AWS account with sufficient permissions to create S3 buckets and CloudFront distributions.
- A Git repository for version control.

## Setup and Usage

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Format and validate the code:
   ```bash
   terraform fmt -check
   terraform validate
   ```

4. Deploy the infrastructure:
   ```bash
   terraform apply
   ```

5. Access the static website using the CloudFront URL provided in the Terraform output.

## Repository Structure

```plaintext
.
├── index.html             # Static website content
├── main.tf                # Terraform configuration for AWS resources
├── variables.tf           # Input variables for Terraform
├── outputs.tf             # Outputs from the Terraform deployment
├── README.md              # Project documentation
```

## Notes

- Ensure your AWS credentials are properly configured before running Terraform commands.
- The CloudFront distribution URL will look like: `https://xxxxxxxx.cloudfront.net`.
