#!/bin/bash
echo "Running instances in AWS Auto Scaling Group $1 are:"

for id in `aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name $1 | grep -i instanceid  | awk '{ print $2}' | tr -d '"'| tr -d ','`
do
    ip=$(aws ec2 describe-instances --instance-ids $id | grep -i PrivateIpAddress | awk '{ print $2 }' | head -1 | tr -d '"'| tr -d ',')
    echo "Instance ID: $id | IP Address: $ip"
done;