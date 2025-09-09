#!/bin/bash

# AWS CLI Basic Commands for Cloud Practitioner Study
# ====================================================
# This script demonstrates essential AWS CLI commands
# Perfect for understanding AWS services through command line

echo "=================================================="
echo "AWS CLI DEMO - Cloud Practitioner Lab"
echo "=================================================="

# Check AWS CLI installation and configuration
echo "1. Checking AWS CLI configuration..."
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed"
    echo "Please install: https://aws.amazon.com/cli/"
    exit 1
fi

echo "✅ AWS CLI found: $(aws --version)"

# Check credentials
echo -e "\n2. Checking AWS credentials..."
if aws sts get-caller-identity &> /dev/null; then
    echo "✅ AWS credentials configured"
    aws sts get-caller-identity --output table
else
    echo "❌ AWS credentials not configured"
    echo "Run: aws configure"
    exit 1
fi

# List available regions
echo -e "\n3. Available AWS regions:"
aws ec2 describe-regions --query 'Regions[*].[RegionName,Endpoint]' --output table

# S3 Operations
echo -e "\n=================================================="
echo "S3 OPERATIONS"
echo "=================================================="

# Generate unique bucket name
BUCKET_NAME="aws-cli-demo-$(date +%s)"
SAMPLE_FILE="sample-cli.txt"
DOWNLOAD_FILE="downloaded-sample-cli.txt"

echo -e "\n4. Creating S3 bucket: $BUCKET_NAME"
if aws s3 mb "s3://$BUCKET_NAME"; then
    echo "✅ Bucket created successfully"
    
    # Create sample file
    echo "Hello from AWS CLI!
This is a demo file for Cloud Practitioner certification study.
Created on: $(date)
Commands used: aws s3 cp, aws s3 ls" > "$SAMPLE_FILE"
    
    echo -e "\n5. Uploading file to S3..."
    aws s3 cp "$SAMPLE_FILE" "s3://$BUCKET_NAME/"
    echo "✅ File uploaded"
    
    echo -e "\n6. Listing bucket contents..."
    aws s3 ls "s3://$BUCKET_NAME/"
    
    echo -e "\n7. Downloading file..."
    aws s3 cp "s3://$BUCKET_NAME/$SAMPLE_FILE" "$DOWNLOAD_FILE"
    echo "✅ File downloaded as $DOWNLOAD_FILE"
    
    echo -e "\n8. Viewing downloaded file content:"
    head -n 2 "$DOWNLOAD_FILE"
    
    echo -e "\n9. Cleaning up S3 resources..."
    aws s3 rm "s3://$BUCKET_NAME/$SAMPLE_FILE"
    aws s3 rb "s3://$BUCKET_NAME"
    echo "✅ S3 cleanup completed"
    
    # Clean local files
    rm -f "$SAMPLE_FILE" "$DOWNLOAD_FILE"
    echo "✅ Local files cleaned up"
else
    echo "❌ Failed to create bucket"
fi

# EC2 Operations (Read-only)
echo -e "\n=================================================="
echo "EC2 INFORMATION"
echo "=================================================="

echo -e "\n10. Listing EC2 instances..."
INSTANCES=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType]' --output table)
if [ ${#INSTANCES} -gt 100 ]; then
    echo "$INSTANCES"
else
    echo "No EC2 instances found in this region"
fi

echo -e "\n11. Available instance types (sample)..."
echo "t2.micro    - Burstable performance, 1 vCPU, 1 GB RAM"
echo "t3.small    - Burstable performance, 2 vCPU, 2 GB RAM"
echo "m5.large    - General purpose, 2 vCPU, 8 GB RAM"
echo "c5.large    - Compute optimized, 2 vCPU, 4 GB RAM"
echo "r5.large    - Memory optimized, 2 vCPU, 16 GB RAM"

# IAM Information (Read-only)
echo -e "\n=================================================="
echo "IAM INFORMATION"
echo "=================================================="

echo -e "\n12. Current user information..."
aws iam get-user --output table 2>/dev/null || echo "No IAM user (might be using roles)"

echo -e "\n13. IAM groups..."
aws iam list-groups --query 'Groups[*].[GroupName,CreateDate]' --output table 2>/dev/null || echo "Unable to list groups (insufficient permissions)"

# Billing and Cost Information
echo -e "\n=================================================="
echo "BILLING AND COST INFORMATION"
echo "=================================================="

echo -e "\n14. Cost and billing commands..."
echo "Note: These require specific billing permissions"
echo "aws ce get-cost-and-usage --help"
echo "aws budgets describe-budgets --help"
echo "aws support describe-trusted-advisor-checks --help"

# Security and Best Practices
echo -e "\n=================================================="
echo "SECURITY BEST PRACTICES"
echo "=================================================="

echo -e "\n15. Security recommendations..."
echo "✅ Enable MFA: aws iam enable-mfa-device"
echo "✅ Use IAM roles for EC2: aws iam create-role"
echo "✅ Enable CloudTrail: aws cloudtrail create-trail"
echo "✅ Monitor with CloudWatch: aws cloudwatch put-metric-alarm"
echo "✅ Use least privilege principle in IAM policies"

# Useful AWS CLI Tips
echo -e "\n=================================================="
echo "USEFUL AWS CLI TIPS"
echo "=================================================="

echo -e "\n16. Helpful CLI options..."
echo "--dry-run        : Preview changes without executing"
echo "--output table   : Format output as table"
echo "--output json    : Format output as JSON"
echo "--query          : Filter output using JMESPath"
echo "--profile        : Use specific AWS profile"
echo "--region         : Override default region"

echo -e "\n17. Configuration commands..."
echo "aws configure list              : Show current configuration"
echo "aws configure list-profiles     : Show available profiles"
echo "aws sts get-caller-identity     : Show current user/role"
echo "aws ec2 describe-regions        : List all regions"

echo -e "\n=================================================="
echo "✅ AWS CLI Demo completed successfully!"
echo "=================================================="

echo -e "\nNext steps:"
echo "1. Practice with different services: EC2, RDS, VPC"
echo "2. Explore CloudFormation for Infrastructure as Code"
echo "3. Try AWS CLI with different output formats"
echo "4. Set up AWS CLI profiles for different environments"
echo "5. Learn about AWS CLI pagination and filtering"

echo -e "\nUseful resources:"
echo "- AWS CLI Reference: https://docs.aws.amazon.com/cli/"
echo "- AWS CLI Examples: https://github.com/aws/aws-cli/tree/v2/awscli/examples"
echo "- JMESPath Tutorial: https://jmespath.org/tutorial.html"
