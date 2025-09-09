/*
AWS S3 Basic Operations with JavaScript/Node.js and AWS SDK v3
==============================================================

This lab demonstrates basic S3 operations using the AWS SDK for JavaScript v3.
Perfect for understanding S3 fundamentals for the Cloud Practitioner exam.

Prerequisites:
- AWS account with appropriate permissions
- AWS CLI configured with credentials
- Node.js 14+ installed
- AWS SDK v3 installed: npm install @aws-sdk/client-s3

Learning Objectives:
- Create and delete S3 buckets
- Upload and download objects
- List buckets and objects
- Set object permissions
- Understand S3 storage classes
*/

import {
    S3Client,
    CreateBucketCommand,
    ListBucketsCommand,
    PutObjectCommand,
    GetObjectCommand,
    ListObjectsV2Command,
    DeleteObjectCommand,
    DeleteBucketCommand,
    HeadBucketCommand
} from '@aws-sdk/client-s3';
import { writeFileSync, readFileSync, unlinkSync, existsSync } from 'fs';

class S3Manager {
    /**
     * Initialize S3 client
     * @param {string} region - AWS region name
     */
    constructor(region = 'us-east-1') {
        this.s3Client = new S3Client({ region });
        this.region = region;
        console.log(`S3 client initialized for region: ${region}`);
    }

    /**
     * Create an S3 bucket
     * @param {string} bucketName - Name of the bucket to create
     * @returns {Promise<boolean>} - True if bucket created successfully
     */
    async createBucket(bucketName) {
        try {
            const command = new CreateBucketCommand({
                Bucket: bucketName,
                // Only add CreateBucketConfiguration for regions other than us-east-1
                ...(this.region !== 'us-east-1' && {
                    CreateBucketConfiguration: {
                        LocationConstraint: this.region
                    }
                })
            });

            await this.s3Client.send(command);
            console.log(`✅ Bucket '${bucketName}' created successfully`);
            return true;

        } catch (error) {
            if (error.name === 'BucketAlreadyExists') {
                console.error(`❌ Bucket '${bucketName}' already exists`);
            } else if (error.name === 'BucketAlreadyOwnedByYou') {
                console.log(`ℹ️ Bucket '${bucketName}' already owned by you`);
                return true;
            } else {
                console.error(`❌ Error creating bucket: ${error.message}`);
            }
            return false;
        }
    }

    /**
     * List all S3 buckets in the account
     * @returns {Promise<string[]>} - Array of bucket names
     */
    async listBuckets() {
        try {
            const command = new ListBucketsCommand({});
            const response = await this.s3Client.send(command);

            const buckets = response.Buckets?.map(bucket => bucket.Name) || [];
            console.log(`📂 Found ${buckets.length} buckets:`);
            buckets.forEach(bucket => console.log(`  - ${bucket}`));

            return buckets;

        } catch (error) {
            console.error(`❌ Error listing buckets: ${error.message}`);
            return [];
        }
    }

    /**
     * Upload a file to S3 bucket
     * @param {string} filePath - Path to the local file
     * @param {string} bucketName - Name of the S3 bucket
     * @param {string} objectKey - S3 object key (filename in S3)
     * @returns {Promise<boolean>} - True if upload successful
     */
    async uploadFile(filePath, bucketName, objectKey = null) {
        if (!objectKey) {
            objectKey = filePath.split('/').pop(); // Use filename as key
        }

        try {
            const fileContent = readFileSync(filePath);

            const command = new PutObjectCommand({
                Bucket: bucketName,
                Key: objectKey,
                Body: fileContent,
                ContentType: 'text/plain'
            });

            await this.s3Client.send(command);
            console.log(`⬆️ File '${filePath}' uploaded to '${bucketName}/${objectKey}'`);
            return true;

        } catch (error) {
            if (error.code === 'ENOENT') {
                console.error(`❌ File '${filePath}' not found`);
            } else {
                console.error(`❌ Error uploading file: ${error.message}`);
            }
            return false;
        }
    }

    /**
     * Download a file from S3 bucket
     * @param {string} bucketName - Name of the S3 bucket
     * @param {string} objectKey - S3 object key
     * @param {string} downloadPath - Local path to save the file
     * @returns {Promise<boolean>} - True if download successful
     */
    async downloadFile(bucketName, objectKey, downloadPath) {
        try {
            const command = new GetObjectCommand({
                Bucket: bucketName,
                Key: objectKey
            });

            const response = await this.s3Client.send(command);
            const chunks = [];

            for await (const chunk of response.Body) {
                chunks.push(chunk);
            }

            const buffer = Buffer.concat(chunks);
            writeFileSync(downloadPath, buffer);

            console.log(`⬇️ File '${objectKey}' downloaded to '${downloadPath}'`);
            return true;

        } catch (error) {
            console.error(`❌ Error downloading file: ${error.message}`);
            return false;
        }
    }

    /**
     * List objects in an S3 bucket
     * @param {string} bucketName - Name of the S3 bucket
     * @param {string} prefix - Prefix to filter objects
     * @returns {Promise<string[]>} - Array of object keys
     */
    async listObjects(bucketName, prefix = '') {
        try {
            const command = new ListObjectsV2Command({
                Bucket: bucketName,
                Prefix: prefix
            });

            const response = await this.s3Client.send(command);

            const objects = response.Contents?.map(obj => obj.Key) || [];
            console.log(`📄 Found ${objects.length} objects in '${bucketName}':`);
            objects.forEach(obj => console.log(`  - ${obj}`));

            return objects;

        } catch (error) {
            console.error(`❌ Error listing objects: ${error.message}`);
            return [];
        }
    }

    /**
     * Delete an object from S3 bucket
     * @param {string} bucketName - Name of the S3 bucket
     * @param {string} objectKey - S3 object key to delete
     * @returns {Promise<boolean>} - True if deletion successful
     */
    async deleteObject(bucketName, objectKey) {
        try {
            const command = new DeleteObjectCommand({
                Bucket: bucketName,
                Key: objectKey
            });

            await this.s3Client.send(command);
            console.log(`🗑️ Object '${objectKey}' deleted from '${bucketName}'`);
            return true;

        } catch (error) {
            console.error(`❌ Error deleting object: ${error.message}`);
            return false;
        }
    }

    /**
     * Delete an S3 bucket (must be empty)
     * @param {string} bucketName - Name of the bucket to delete
     * @returns {Promise<boolean>} - True if deletion successful
     */
    async deleteBucket(bucketName) {
        try {
            // First, delete all objects in the bucket
            const objects = await this.listObjects(bucketName);
            for (const objectKey of objects) {
                await this.deleteObject(bucketName, objectKey);
            }

            // Then delete the bucket
            const command = new DeleteBucketCommand({
                Bucket: bucketName
            });

            await this.s3Client.send(command);
            console.log(`🗑️ Bucket '${bucketName}' deleted successfully`);
            return true;

        } catch (error) {
            console.error(`❌ Error deleting bucket: ${error.message}`);
            return false;
        }
    }

    /**
     * Check if bucket exists
     * @param {string} bucketName - Name of the bucket to check
     * @returns {Promise<boolean>} - True if bucket exists
     */
    async bucketExists(bucketName) {
        try {
            const command = new HeadBucketCommand({
                Bucket: bucketName
            });
            await this.s3Client.send(command);
            return true;
        } catch (error) {
            return false;
        }
    }
}

/**
 * Demonstration of S3 operations for learning purposes
 */
async function demoS3Operations() {
    console.log('\n' + '='.repeat(50));
    console.log('AWS S3 DEMO - Cloud Practitioner Lab (Node.js)');
    console.log('='.repeat(50));

    // Initialize S3 manager
    const s3Manager = new S3Manager();

    // Demo bucket name (must be globally unique)
    const timestamp = Math.floor(Date.now() / 1000);
    const bucketName = `aws-cloudpractitioner-demo-js-${timestamp}`;

    try {
        // 1. List existing buckets
        console.log('\n1. Listing existing buckets...');
        await s3Manager.listBuckets();

        // 2. Create a new bucket
        console.log(`\n2. Creating bucket: ${bucketName}`);
        const bucketCreated = await s3Manager.createBucket(bucketName);

        if (bucketCreated) {
            // 3. Create a sample file to upload
            const sampleFile = 'sample-js.txt';
            const sampleContent = `Hello from AWS S3 using Node.js!
This is a demo file for Cloud Practitioner certification study.
Created on: ${new Date().toISOString()}
SDK Version: AWS SDK for JavaScript v3`;

            writeFileSync(sampleFile, sampleContent);
            console.log(`✅ Sample file created: ${sampleFile}`);

            // 4. Upload the file
            console.log(`\n3. Uploading file: ${sampleFile}`);
            await s3Manager.uploadFile(sampleFile, bucketName);

            // 5. List objects in bucket
            console.log(`\n4. Listing objects in bucket: ${bucketName}`);
            await s3Manager.listObjects(bucketName);

            // 6. Download the file with a new name
            const downloadFile = 'downloaded-sample-js.txt';
            console.log(`\n5. Downloading file as: ${downloadFile}`);
            await s3Manager.downloadFile(bucketName, sampleFile, downloadFile);

            // Verify download
            if (existsSync(downloadFile)) {
                const content = readFileSync(downloadFile, 'utf8');
                console.log('📖 Downloaded file content preview:');
                console.log(content.split('\n')[0]);
            }

            // 7. Cleanup
            console.log('\n6. Cleaning up resources...');
            await s3Manager.deleteObject(bucketName, sampleFile);
            await s3Manager.deleteBucket(bucketName);

            // Clean up local files
            [sampleFile, downloadFile].forEach(file => {
                if (existsSync(file)) {
                    unlinkSync(file);
                }
            });

            console.log('🧹 Local files cleaned up');
            console.log('\n✅ Demo completed successfully!');
        }

    } catch (error) {
        console.error(`\n❌ Demo failed: ${error.message}`);
        console.log('Please check your AWS credentials and permissions.');

        // Attempt cleanup if bucket was created
        try {
            const bucketExists = await s3Manager.bucketExists(bucketName);
            if (bucketExists) {
                console.log('🧹 Attempting cleanup...');
                const objects = await s3Manager.listObjects(bucketName);
                for (const objectKey of objects) {
                    await s3Manager.deleteObject(bucketName, objectKey);
                }
                await s3Manager.deleteBucket(bucketName);
                console.log('✅ Cleanup completed');
            }
        } catch (cleanupError) {
            console.log('⚠️ Manual cleanup may be required');
        }
    }
}

/**
 * Additional S3 examples for learning
 */
async function additionalS3Examples() {
    console.log('\n' + '='.repeat(50));
    console.log('Additional S3 Examples');
    console.log('='.repeat(50));

    const s3Manager = new S3Manager();

    // Example: Different storage classes
    console.log('\n📚 S3 Storage Classes Information:');
    const storageClasses = [
        'STANDARD - For frequently accessed data',
        'STANDARD_IA - For infrequently accessed data',
        'ONEZONE_IA - For non-critical, infrequently accessed data',
        'GLACIER - For archive data (minutes to hours retrieval)',
        'DEEP_ARCHIVE - For long-term archive (12+ hours retrieval)'
    ];

    storageClasses.forEach(cls => console.log(`  - ${cls}`));

    // Example: Best practices
    console.log('\n💡 S3 Best Practices:');
    const bestPractices = [
        'Use meaningful bucket and object names',
        'Enable versioning for important data',
        'Use lifecycle policies to manage costs',
        'Enable server-side encryption',
        'Use CloudFront for global content delivery',
        'Monitor access with CloudTrail',
        'Implement proper IAM policies'
    ];

    bestPractices.forEach(practice => console.log(`  - ${practice}`));
}

// Export for use in other modules
export { S3Manager };

// Run demo if this file is executed directly
if (import.meta.url === `file://${process.argv[1]}`) {
    /**
     * Main execution function
     * 
     * To run this lab:
     * 1. Ensure AWS credentials are configured
     * 2. Install dependencies: npm install @aws-sdk/client-s3
     * 3. Run: node s3_basic_operations.js
     */

    console.log('🚀 Starting AWS S3 Labs with Node.js...\n');

    // Check if AWS SDK is available
    try {
        await demoS3Operations();
        await additionalS3Examples();
    } catch (error) {
        console.error('❌ Failed to run demo:', error.message);
        console.log('\n📋 Prerequisites:');
        console.log('  1. Install Node.js 14+');
        console.log('  2. Install AWS SDK: npm install @aws-sdk/client-s3');
        console.log('  3. Configure AWS credentials: aws configure');
        console.log('  4. Ensure you have S3 permissions');
    }
}
