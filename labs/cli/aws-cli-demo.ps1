# AWS CLI Commands for Windows PowerShell
# =======================================
# PowerShell version of AWS CLI commands for Cloud Practitioner study

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "AWS CLI DEMO - Cloud Practitioner Lab (PowerShell)" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# Check AWS CLI installation
Write-Host "`n1. Checking AWS CLI configuration..." -ForegroundColor Yellow
try {
    $awsVersion = aws --version 2>$null
    if ($awsVersion) {
        Write-Host "✅ AWS CLI found: $awsVersion" -ForegroundColor Green
    }
    else {
        throw "AWS CLI not found"
    }
}
catch {
    Write-Host "❌ AWS CLI is not installed" -ForegroundColor Red
    Write-Host "Please install: https://aws.amazon.com/cli/" -ForegroundColor Yellow
    exit 1
}

# Check credentials
Write-Host "`n2. Checking AWS credentials..." -ForegroundColor Yellow
try {
    $callerIdentity = aws sts get-caller-identity --output json 2>$null | ConvertFrom-Json
    if ($callerIdentity) {
        Write-Host "✅ AWS credentials configured" -ForegroundColor Green
        Write-Host "User/Role: $($callerIdentity.Arn)" -ForegroundColor White
        Write-Host "Account: $($callerIdentity.Account)" -ForegroundColor White
    }
    else {
        throw "No credentials"
    }
}
catch {
    Write-Host "❌ AWS credentials not configured" -ForegroundColor Red
    Write-Host "Run: aws configure" -ForegroundColor Yellow
    exit 1
}

# List available regions
Write-Host "`n3. Available AWS regions (first 10):" -ForegroundColor Yellow
try {
    $regions = aws ec2 describe-regions --query 'Regions[0:10].[RegionName,Endpoint]' --output json | ConvertFrom-Json
    foreach ($region in $regions) {
        Write-Host "  - $($region[0]): $($region[1])" -ForegroundColor White
    }
}
catch {
    Write-Host "❌ Unable to list regions" -ForegroundColor Red
}

# S3 Operations
Write-Host "`n==================================================" -ForegroundColor Cyan
Write-Host "S3 OPERATIONS" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# Generate unique bucket name
$timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
$bucketName = "aws-cli-demo-ps-$timestamp"
$sampleFile = "sample-cli-ps.txt"
$downloadFile = "downloaded-sample-cli-ps.txt"

Write-Host "`n4. Creating S3 bucket: $bucketName" -ForegroundColor Yellow
try {
    $result = aws s3 mb "s3://$bucketName" 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Bucket created successfully" -ForegroundColor Green
        
        # Create sample file
        $sampleContent = @"
Hello from AWS CLI with PowerShell!
This is a demo file for Cloud Practitioner certification study.
Created on: $(Get-Date)
Commands used: aws s3 cp, aws s3 ls
"@
        Set-Content -Path $sampleFile -Value $sampleContent
        
        Write-Host "`n5. Uploading file to S3..." -ForegroundColor Yellow
        aws s3 cp $sampleFile "s3://$bucketName/"
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ File uploaded" -ForegroundColor Green
            
            Write-Host "`n6. Listing bucket contents..." -ForegroundColor Yellow
            aws s3 ls "s3://$bucketName/"
            
            Write-Host "`n7. Downloading file..." -ForegroundColor Yellow
            aws s3 cp "s3://$bucketName/$sampleFile" $downloadFile
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ File downloaded as $downloadFile" -ForegroundColor Green
                
                Write-Host "`n8. Viewing downloaded file content:" -ForegroundColor Yellow
                $content = Get-Content $downloadFile -TotalCount 2
                Write-Host $content[0] -ForegroundColor White
            }
            
            Write-Host "`n9. Cleaning up S3 resources..." -ForegroundColor Yellow
            aws s3 rm "s3://$bucketName/$sampleFile"
            aws s3 rb "s3://$bucketName"
            Write-Host "✅ S3 cleanup completed" -ForegroundColor Green
        }
        
        # Clean local files
        if (Test-Path $sampleFile) { Remove-Item $sampleFile -Force }
        if (Test-Path $downloadFile) { Remove-Item $downloadFile -Force }
        Write-Host "✅ Local files cleaned up" -ForegroundColor Green
        
    }
    else {
        throw "Failed to create bucket"
    }
}
catch {
    Write-Host "❌ S3 operations failed: $($_.Exception.Message)" -ForegroundColor Red
}

# EC2 Operations (Read-only)
Write-Host "`n==================================================" -ForegroundColor Cyan
Write-Host "EC2 INFORMATION" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

Write-Host "`n10. Listing EC2 instances..." -ForegroundColor Yellow
try {
    $instances = aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType]' --output json | ConvertFrom-Json
    if ($instances -and $instances.Count -gt 0) {
        foreach ($reservation in $instances) {
            foreach ($instance in $reservation) {
                Write-Host "  Instance: $($instance[0]), State: $($instance[1]), Type: $($instance[2])" -ForegroundColor White
            }
        }
    }
    else {
        Write-Host "No EC2 instances found in this region" -ForegroundColor White
    }
}
catch {
    Write-Host "❌ Unable to list EC2 instances" -ForegroundColor Red
}

Write-Host "`n11. Available instance types (sample)..." -ForegroundColor Yellow
$instanceTypes = @(
    "t2.micro    - Burstable performance, 1 vCPU, 1 GB RAM",
    "t3.small    - Burstable performance, 2 vCPU, 2 GB RAM", 
    "m5.large    - General purpose, 2 vCPU, 8 GB RAM",
    "c5.large    - Compute optimized, 2 vCPU, 4 GB RAM",
    "r5.large    - Memory optimized, 2 vCPU, 16 GB RAM"
)
foreach ($type in $instanceTypes) {
    Write-Host "  $type" -ForegroundColor White
}

# IAM Information (Read-only)
Write-Host "`n==================================================" -ForegroundColor Cyan
Write-Host "IAM INFORMATION" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

Write-Host "`n12. Current user information..." -ForegroundColor Yellow
try {
    $user = aws iam get-user --output json 2>$null | ConvertFrom-Json
    if ($user) {
        Write-Host "User Name: $($user.User.UserName)" -ForegroundColor White
        Write-Host "User ARN: $($user.User.Arn)" -ForegroundColor White
    }
    else {
        Write-Host "No IAM user (might be using roles)" -ForegroundColor White
    }
}
catch {
    Write-Host "Unable to get user information" -ForegroundColor White
}

Write-Host "`n13. IAM groups..." -ForegroundColor Yellow
try {
    $groups = aws iam list-groups --query 'Groups[*].[GroupName,CreateDate]' --output json 2>$null | ConvertFrom-Json
    if ($groups -and $groups.Count -gt 0) {
        foreach ($group in $groups) {
            Write-Host "  Group: $($group[0]), Created: $($group[1])" -ForegroundColor White
        }
    }
    else {
        Write-Host "No IAM groups found or insufficient permissions" -ForegroundColor White
    }
}
catch {
    Write-Host "Unable to list groups (insufficient permissions)" -ForegroundColor White
}

# Cost and Billing Information
Write-Host "`n==================================================" -ForegroundColor Cyan
Write-Host "BILLING AND COST INFORMATION" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

Write-Host "`n14. Cost and billing commands..." -ForegroundColor Yellow
Write-Host "Note: These require specific billing permissions" -ForegroundColor Yellow
$billingCommands = @(
    "aws ce get-cost-and-usage --help",
    "aws budgets describe-budgets --help", 
    "aws support describe-trusted-advisor-checks --help"
)
foreach ($cmd in $billingCommands) {
    Write-Host "  $cmd" -ForegroundColor White
}

# Security Best Practices
Write-Host "`n==================================================" -ForegroundColor Cyan
Write-Host "SECURITY BEST PRACTICES" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

Write-Host "`n15. Security recommendations..." -ForegroundColor Yellow
$securityTips = @(
    "✅ Enable MFA: aws iam enable-mfa-device",
    "✅ Use IAM roles for EC2: aws iam create-role",
    "✅ Enable CloudTrail: aws cloudtrail create-trail",
    "✅ Monitor with CloudWatch: aws cloudwatch put-metric-alarm",
    "✅ Use least privilege principle in IAM policies"
)
foreach ($tip in $securityTips) {
    Write-Host "  $tip" -ForegroundColor Green
}

# Useful CLI Tips
Write-Host "`n==================================================" -ForegroundColor Cyan
Write-Host "USEFUL AWS CLI TIPS" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

Write-Host "`n16. Helpful CLI options..." -ForegroundColor Yellow
$cliOptions = @{
    "--dry-run"      = "Preview changes without executing"
    "--output table" = "Format output as table"
    "--output json"  = "Format output as JSON"
    "--query"        = "Filter output using JMESPath"
    "--profile"      = "Use specific AWS profile"
    "--region"       = "Override default region"
}
foreach ($option in $cliOptions.GetEnumerator()) {
    Write-Host "  $($option.Key)".PadRight(20) + ": $($option.Value)" -ForegroundColor White
}

Write-Host "`n17. Configuration commands..." -ForegroundColor Yellow
$configCommands = @(
    "aws configure list              : Show current configuration",
    "aws configure list-profiles     : Show available profiles",
    "aws sts get-caller-identity     : Show current user/role", 
    "aws ec2 describe-regions        : List all regions"
)
foreach ($cmd in $configCommands) {
    Write-Host "  $cmd" -ForegroundColor White
}

Write-Host "`n==================================================" -ForegroundColor Cyan
Write-Host "✅ AWS CLI Demo completed successfully!" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Cyan

Write-Host "`nNext steps:" -ForegroundColor Yellow
$nextSteps = @(
    "1. Practice with different services: EC2, RDS, VPC",
    "2. Explore CloudFormation for Infrastructure as Code",
    "3. Try AWS CLI with different output formats",
    "4. Set up AWS CLI profiles for different environments",
    "5. Learn about AWS CLI pagination and filtering"
)
foreach ($step in $nextSteps) {
    Write-Host "  $step" -ForegroundColor White
}

Write-Host "`nUseful resources:" -ForegroundColor Yellow
$resources = @(
    "- AWS CLI Reference: https://docs.aws.amazon.com/cli/",
    "- AWS CLI Examples: https://github.com/aws/aws-cli/tree/v2/awscli/examples",
    "- JMESPath Tutorial: https://jmespath.org/tutorial.html"
)
foreach ($resource in $resources) {
    Write-Host "  $resource" -ForegroundColor Cyan
}
