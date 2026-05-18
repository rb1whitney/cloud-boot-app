#!/bin/bash
# AWS Discovery Script v1.0
# Purpose: Ground the agent in the current AWS environment.

echo "### AWS Identity Check"
aws sts get-caller-identity --output table

echo "### Current Region & Account Settings"
aws configure list

echo "### Active S3 Buckets (Sampling)"
aws s3 ls | head -n 5

echo "### EC2 Instance Summary (Running)"
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,PublicIpAddress]' --output table

echo "### VPC Inventory"
aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,CidrBlock,IsDefault]' --output table
