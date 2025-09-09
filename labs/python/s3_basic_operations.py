"""
AWS S3 Basic Operations with Python and boto3
==============================================

This lab demonstrates basic S3 operations using Python's boto3 library.
Perfect for understanding S3 fundamentals for the Cloud Practitioner exam.

Prerequisites:
- AWS account with appropriate permissions
- AWS CLI configured with credentials
- Python 3.6+ installed
- boto3 installed: pip install boto3

Learning Objectives:
- Create and delete S3 buckets
- Upload and download objects
- List buckets and objects
- Set object permissions
- Understand S3 storage classes
"""

import boto3
import json
from botocore.exceptions import ClientError, NoCredentialsError
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class S3Manager:
    """A class to manage S3 operations for learning purposes."""
    
    def __init__(self, region_name='us-east-1'):
        """
        Initialize S3 client
        
        Args:
            region_name (str): AWS region name
        """
        try:
            self.s3_client = boto3.client('s3', region_name=region_name)
            self.s3_resource = boto3.resource('s3', region_name=region_name)
            self.region = region_name
            logger.info(f"S3 client initialized for region: {region_name}")
        except NoCredentialsError:
            logger.error("AWS credentials not found. Please configure AWS CLI.")
            raise
    
    def create_bucket(self, bucket_name):
        """
        Create an S3 bucket
        
        Args:
            bucket_name (str): Name of the bucket to create
            
        Returns:
            bool: True if bucket created successfully, False otherwise
        """
        try:
            if self.region == 'us-east-1':
                # us-east-1 doesn't need location constraint
                self.s3_client.create_bucket(Bucket=bucket_name)
            else:
                # Other regions need location constraint
                self.s3_client.create_bucket(
                    Bucket=bucket_name,
                    CreateBucketConfiguration={'LocationConstraint': self.region}
                )
            
            logger.info(f"Bucket '{bucket_name}' created successfully")
            return True
            
        except ClientError as e:
            error_code = e.response['Error']['Code']
            if error_code == 'BucketAlreadyExists':
                logger.error(f"Bucket '{bucket_name}' already exists")
            elif error_code == 'BucketAlreadyOwnedByYou':
                logger.info(f"Bucket '{bucket_name}' already owned by you")
                return True
            else:
                logger.error(f"Error creating bucket: {e}")
            return False
    
    def list_buckets(self):
        """
        List all S3 buckets in the account
        
        Returns:
            list: List of bucket names
        """
        try:
            response = self.s3_client.list_buckets()
            buckets = [bucket['Name'] for bucket in response['Buckets']]
            
            logger.info(f"Found {len(buckets)} buckets:")
            for bucket in buckets:
                logger.info(f"  - {bucket}")
            
            return buckets
            
        except ClientError as e:
            logger.error(f"Error listing buckets: {e}")
            return []
    
    def upload_file(self, file_path, bucket_name, object_key=None):
        """
        Upload a file to S3 bucket
        
        Args:
            file_path (str): Path to the local file
            bucket_name (str): Name of the S3 bucket
            object_key (str): S3 object key (filename in S3)
            
        Returns:
            bool: True if upload successful, False otherwise
        """
        if object_key is None:
            object_key = file_path.split('/')[-1]  # Use filename as key
        
        try:
            self.s3_client.upload_file(file_path, bucket_name, object_key)
            logger.info(f"File '{file_path}' uploaded to '{bucket_name}/{object_key}'")
            return True
            
        except FileNotFoundError:
            logger.error(f"File '{file_path}' not found")
            return False
        except ClientError as e:
            logger.error(f"Error uploading file: {e}")
            return False
    
    def download_file(self, bucket_name, object_key, download_path):
        """
        Download a file from S3 bucket
        
        Args:
            bucket_name (str): Name of the S3 bucket
            object_key (str): S3 object key
            download_path (str): Local path to save the file
            
        Returns:
            bool: True if download successful, False otherwise
        """
        try:
            self.s3_client.download_file(bucket_name, object_key, download_path)
            logger.info(f"File '{object_key}' downloaded to '{download_path}'")
            return True
            
        except ClientError as e:
            logger.error(f"Error downloading file: {e}")
            return False
    
    def list_objects(self, bucket_name, prefix=''):
        """
        List objects in an S3 bucket
        
        Args:
            bucket_name (str): Name of the S3 bucket
            prefix (str): Prefix to filter objects
            
        Returns:
            list: List of object keys
        """
        try:
            response = self.s3_client.list_objects_v2(
                Bucket=bucket_name,
                Prefix=prefix
            )
            
            if 'Contents' in response:
                objects = [obj['Key'] for obj in response['Contents']]
                logger.info(f"Found {len(objects)} objects in '{bucket_name}':")
                for obj in objects:
                    logger.info(f"  - {obj}")
                return objects
            else:
                logger.info(f"No objects found in '{bucket_name}'")
                return []
                
        except ClientError as e:
            logger.error(f"Error listing objects: {e}")
            return []
    
    def delete_object(self, bucket_name, object_key):
        """
        Delete an object from S3 bucket
        
        Args:
            bucket_name (str): Name of the S3 bucket
            object_key (str): S3 object key to delete
            
        Returns:
            bool: True if deletion successful, False otherwise
        """
        try:
            self.s3_client.delete_object(Bucket=bucket_name, Key=object_key)
            logger.info(f"Object '{object_key}' deleted from '{bucket_name}'")
            return True
            
        except ClientError as e:
            logger.error(f"Error deleting object: {e}")
            return False
    
    def delete_bucket(self, bucket_name):
        """
        Delete an S3 bucket (must be empty)
        
        Args:
            bucket_name (str): Name of the bucket to delete
            
        Returns:
            bool: True if deletion successful, False otherwise
        """
        try:
            # First, delete all objects in the bucket
            objects = self.list_objects(bucket_name)
            for obj_key in objects:
                self.delete_object(bucket_name, obj_key)
            
            # Then delete the bucket
            self.s3_client.delete_bucket(Bucket=bucket_name)
            logger.info(f"Bucket '{bucket_name}' deleted successfully")
            return True
            
        except ClientError as e:
            logger.error(f"Error deleting bucket: {e}")
            return False


def demo_s3_operations():
    """
    Demonstration of S3 operations for learning purposes
    """
    # Initialize S3 manager
    s3_manager = S3Manager()
    
    # Demo bucket name (must be globally unique)
    import time
    bucket_name = f"aws-cloudpractitioner-demo-{int(time.time())}"
    
    print("\n" + "="*50)
    print("AWS S3 DEMO - Cloud Practitioner Lab")
    print("="*50)
    
    try:
        # 1. List existing buckets
        print("\n1. Listing existing buckets...")
        s3_manager.list_buckets()
        
        # 2. Create a new bucket
        print(f"\n2. Creating bucket: {bucket_name}")
        if s3_manager.create_bucket(bucket_name):
            
            # 3. Create a sample file to upload
            sample_file = "sample.txt"
            with open(sample_file, 'w') as f:
                f.write("Hello from AWS S3!\nThis is a demo file for Cloud Practitioner certification study.")
            
            # 4. Upload the file
            print(f"\n3. Uploading file: {sample_file}")
            s3_manager.upload_file(sample_file, bucket_name)
            
            # 5. List objects in bucket
            print(f"\n4. Listing objects in bucket: {bucket_name}")
            s3_manager.list_objects(bucket_name)
            
            # 6. Download the file with a new name
            download_file = "downloaded_sample.txt"
            print(f"\n5. Downloading file as: {download_file}")
            s3_manager.download_file(bucket_name, sample_file, download_file)
            
            # 7. Cleanup
            print("\n6. Cleaning up resources...")
            s3_manager.delete_object(bucket_name, sample_file)
            s3_manager.delete_bucket(bucket_name)
            
            # Clean up local files
            import os
            if os.path.exists(sample_file):
                os.remove(sample_file)
            if os.path.exists(download_file):
                os.remove(download_file)
            
            print("\n✅ Demo completed successfully!")
        
    except Exception as e:
        logger.error(f"Demo failed: {e}")
        print("\n❌ Demo failed. Check the logs above.")


if __name__ == "__main__":
    """
    Run the S3 demo
    
    To run this lab:
    1. Ensure AWS credentials are configured
    2. Install boto3: pip install boto3
    3. Run: python s3_basic_operations.py
    """
    demo_s3_operations()
