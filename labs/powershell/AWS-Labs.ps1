# PowerShell AWS Labs - Getting Started

# AWS S3 Basic Operations with PowerShell
# =======================================
# This lab demonstrates basic S3 operations using AWS Tools for PowerShell
# Perfect for understanding S3 fundamentals for the Cloud Practitioner exam

# Prerequisites:
# - AWS account with appropriate permissions  
# - AWS Tools for PowerShell installed
# - AWS credentials configured

<#
.SYNOPSIS
    Demonstrates basic AWS S3 operations using PowerShell

.DESCRIPTION
    This script shows how to:
    - Create and delete S3 buckets
    - Upload and download objects
    - List buckets and objects
    - Clean up resources

.EXAMPLE
    .\S3-BasicOperations.ps1
#>

# Import AWS modules
Import-Module AWS.Tools.S3

# Set AWS credentials (if not already configured)
# Set-AWSCredential -AccessKey "your-access-key" -SecretKey "your-secret-key" -StoreAs "default"

# Set default region
Set-DefaultAWSRegion -Region "us-east-1"

function Show-S3Demo {
    <#
    .SYNOPSIS
        Demonstrates S3 operations for Cloud Practitioner certification study
    #>
    
    Write-Host "`n" + "="*50 -ForegroundColor Cyan
    Write-Host "AWS S3 DEMO - Cloud Practitioner Lab" -ForegroundColor Cyan
    Write-Host "="*50 -ForegroundColor Cyan
    
    # Generate unique bucket name
    $timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
    $bucketName = "aws-cloudpractitioner-demo-ps-$timestamp"
    
    try {
        # 1. List existing buckets
        Write-Host "`n1. Listing existing buckets..." -ForegroundColor Yellow
        $buckets = Get-S3Bucket
        if ($buckets) {
            Write-Host "Found $($buckets.Count) buckets:" -ForegroundColor Green
            foreach ($bucket in $buckets) {
                Write-Host "  - $($bucket.BucketName)" -ForegroundColor White
            }
        }
        else {
            Write-Host "No buckets found." -ForegroundColor White
        }
        
        # 2. Create a new bucket
        Write-Host "`n2. Creating bucket: $bucketName" -ForegroundColor Yellow
        $newBucket = New-S3Bucket -BucketName $bucketName -Region "us-east-1"
        if ($newBucket) {
            Write-Host "✅ Bucket created successfully" -ForegroundColor Green
            
            # 3. Create a sample file to upload
            $sampleFile = "sample-ps.txt"
            $sampleContent = @"
Hello from AWS S3 using PowerShell!
This is a demo file for Cloud Practitioner certification study.
Created on: $(Get-Date)
"@
            Set-Content -Path $sampleFile -Value $sampleContent
            Write-Host "✅ Sample file created: $sampleFile" -ForegroundColor Green
            
            # 4. Upload the file
            Write-Host "`n3. Uploading file: $sampleFile" -ForegroundColor Yellow
            Write-S3Object -BucketName $bucketName -File $sampleFile -Key $sampleFile
            Write-Host "✅ File uploaded successfully" -ForegroundColor Green
            
            # 5. List objects in bucket
            Write-Host "`n4. Listing objects in bucket: $bucketName" -ForegroundColor Yellow
            $objects = Get-S3Object -BucketName $bucketName
            if ($objects) {
                Write-Host "Found $($objects.Count) objects:" -ForegroundColor Green
                foreach ($obj in $objects) {
                    Write-Host "  - $($obj.Key) (Size: $($obj.Size) bytes)" -ForegroundColor White
                }
            }
            
            # 6. Download the file with a new name
            $downloadFile = "downloaded-sample-ps.txt"
            Write-Host "`n5. Downloading file as: $downloadFile" -ForegroundColor Yellow
            Read-S3Object -BucketName $bucketName -Key $sampleFile -File $downloadFile
            Write-Host "✅ File downloaded successfully" -ForegroundColor Green
            
            # Verify download
            if (Test-Path $downloadFile) {
                $content = Get-Content $downloadFile
                Write-Host "Downloaded file content preview:" -ForegroundColor Cyan
                Write-Host $content[0] -ForegroundColor White
            }
            
            # 7. Cleanup
            Write-Host "`n6. Cleaning up resources..." -ForegroundColor Yellow
            
            # Delete object
            Remove-S3Object -BucketName $bucketName -Key $sampleFile -Force
            Write-Host "✅ Object deleted" -ForegroundColor Green
            
            # Delete bucket
            Remove-S3Bucket -BucketName $bucketName -Force
            Write-Host "✅ Bucket deleted" -ForegroundColor Green
            
            # Clean up local files
            if (Test-Path $sampleFile) { Remove-Item $sampleFile -Force }
            if (Test-Path $downloadFile) { Remove-Item $downloadFile -Force }
            Write-Host "✅ Local files cleaned up" -ForegroundColor Green
            
            Write-Host "`n✅ Demo completed successfully!" -ForegroundColor Green
        }
        
    }
    catch {
        Write-Host "`n❌ Demo failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Please check your AWS credentials and permissions." -ForegroundColor Yellow
        
        # Attempt cleanup if bucket was created
        try {
            if (Get-S3Bucket -BucketName $bucketName -ErrorAction SilentlyContinue) {
                Write-Host "Attempting cleanup..." -ForegroundColor Yellow
                $objects = Get-S3Object -BucketName $bucketName -ErrorAction SilentlyContinue
                if ($objects) {
                    foreach ($obj in $objects) {
                        Remove-S3Object -BucketName $bucketName -Key $obj.Key -Force -ErrorAction SilentlyContinue
                    }
                }
                Remove-S3Bucket -BucketName $bucketName -Force -ErrorAction SilentlyContinue
                Write-Host "✅ Cleanup completed" -ForegroundColor Green
            }
        }
        catch {
            Write-Host "⚠️ Manual cleanup may be required" -ForegroundColor Yellow
        }
    }
}

function Show-EC2Demo {
    <#
    .SYNOPSIS
        Demonstrates basic EC2 operations
    #>
    
    Write-Host "`n" + "="*50 -ForegroundColor Cyan
    Write-Host "AWS EC2 DEMO - Instance Information" -ForegroundColor Cyan
    Write-Host "="*50 -ForegroundColor Cyan
    
    try {
        # List EC2 instances
        Write-Host "`n1. Listing EC2 instances..." -ForegroundColor Yellow
        $instances = Get-EC2Instance
        
        if ($instances) {
            foreach ($reservation in $instances) {
                foreach ($instance in $reservation.Instances) {
                    Write-Host "Instance ID: $($instance.InstanceId)" -ForegroundColor White
                    Write-Host "  State: $($instance.State.Name)" -ForegroundColor Green
                    Write-Host "  Type: $($instance.InstanceType)" -ForegroundColor White
                    Write-Host "  Launch Time: $($instance.LaunchTime)" -ForegroundColor White
                    Write-Host ""
                }
            }
        }
        else {
            Write-Host "No EC2 instances found in this region." -ForegroundColor White
        }
        
        # List available instance types
        Write-Host "`n2. Available instance types (sample):" -ForegroundColor Yellow
        $instanceTypes = @("t2.micro", "t2.small", "t3.micro", "t3.small", "m5.large")
        foreach ($type in $instanceTypes) {
            Write-Host "  - $type" -ForegroundColor White
        }
        
        # Show regions
        Write-Host "`n3. Available AWS regions:" -ForegroundColor Yellow
        $regions = Get-AWSRegion | Select-Object -First 10
        foreach ($region in $regions) {
            Write-Host "  - $($region.RegionName): $($region.DisplayName)" -ForegroundColor White
        }
        
    }
    catch {
        Write-Host "❌ Error accessing EC2 information: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Show-IAMDemo {
    <#
    .SYNOPSIS
        Demonstrates basic IAM operations
    #>
    
    Write-Host "`n" + "="*50 -ForegroundColor Cyan
    Write-Host "AWS IAM DEMO - Identity Information" -ForegroundColor Cyan
    Write-Host "="*50 -ForegroundColor Cyan
    
    try {
        # Get current user
        Write-Host "`n1. Current IAM user information..." -ForegroundColor Yellow
        $user = Get-IAMUser
        if ($user) {
            Write-Host "User Name: $($user.UserName)" -ForegroundColor Green
            Write-Host "User ID: $($user.UserId)" -ForegroundColor White
            Write-Host "ARN: $($user.Arn)" -ForegroundColor White
            Write-Host "Created: $($user.CreateDate)" -ForegroundColor White
        }
        
        # List IAM groups
        Write-Host "`n2. IAM groups..." -ForegroundColor Yellow
        $groups = Get-IAMGroupList
        if ($groups) {
            Write-Host "Found $($groups.Count) groups:" -ForegroundColor Green
            foreach ($group in $groups) {
                Write-Host "  - $($group.GroupName)" -ForegroundColor White
            }
        }
        else {
            Write-Host "No IAM groups found." -ForegroundColor White
        }
        
        # List IAM policies (first 10)
        Write-Host "`n3. IAM policies (sample)..." -ForegroundColor Yellow
        $policies = Get-IAMPolicyList -MaxItem 10
        if ($policies) {
            foreach ($policy in $policies) {
                Write-Host "  - $($policy.PolicyName)" -ForegroundColor White
            }
        }
        
    }
    catch {
        Write-Host "❌ Error accessing IAM information: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Note: This might be due to insufficient permissions." -ForegroundColor Yellow
    }
}

# Main execution
function Start-AWSLabs {
    <#
    .SYNOPSIS
        Main function to run AWS PowerShell labs
    #>
    
    Write-Host "AWS Cloud Practitioner Labs - PowerShell Edition" -ForegroundColor Magenta
    Write-Host "Choose a lab to run:" -ForegroundColor White
    Write-Host "1. S3 Basic Operations" -ForegroundColor Green
    Write-Host "2. EC2 Information" -ForegroundColor Green  
    Write-Host "3. IAM Information" -ForegroundColor Green
    Write-Host "4. Run All Labs" -ForegroundColor Green
    Write-Host "Q. Quit" -ForegroundColor Red
    
    $choice = Read-Host "`nEnter your choice"
    
    switch ($choice.ToUpper()) {
        "1" { Show-S3Demo }
        "2" { Show-EC2Demo }
        "3" { Show-IAMDemo }
        "4" { 
            Show-S3Demo
            Show-EC2Demo
            Show-IAMDemo
        }
        "Q" { 
            Write-Host "Goodbye!" -ForegroundColor Magenta
            return
        }
        default {
            Write-Host "Invalid choice. Please try again." -ForegroundColor Red
            Start-AWSLabs
        }
    }
}

# Check if AWS modules are available
if (-not (Get-Module -ListAvailable -Name AWS.Tools.S3)) {
    Write-Host "AWS Tools for PowerShell not found!" -ForegroundColor Red
    Write-Host "Please install using: Install-Module -Name AWS.Tools.Installer" -ForegroundColor Yellow
    Write-Host "Then: Install-AWSToolsModule AWS.Tools.S3,AWS.Tools.EC2,AWS.Tools.IdentityManagement" -ForegroundColor Yellow
    exit 1
}

# Run the labs
Start-AWSLabs
