#!/bin/bash

# My Variables:
aws_region="us-east-2"

vpc_name="vpc-group-4"
vpc_cidr="10.0.0.0/16"

security_group_name="sec-group-4" #Group names may not be in the format sg-*. (sg-group-4)

subnet_public_name_1="ohio-2a"
subnet_public_cidr_1="10.0.1.0/24"
subnet_public_zone_1="us-east-2a"

subnet_public_name_2="ohio-2b"
subnet_public_cidr_2="10.0.2.0/24"
subnet_public_zone_2="us-east-2b"

subnet_public_name_3="ohio-2c"
subnet_public_cidr_3="10.0.3.0/24"
subnet_public_zone_3="us-east-2c"

instance_name_1="ec2a-group-4"
instance_name_2="ec2b-group-4"
instance_name_3="ec2c-group-4"
instance_type="t2.micro"
ami_id="ami-0f3c9c466bb525749"
key_name="my_mac_key"
route_table_name="rt-group4"

echo "Task-1"
# Create VPC
echo "Creating VPC..."
vpc_id=$(aws ec2 create-vpc --cidr-block $vpc_cidr \
                --query Vpc.VpcId \
                --output text \
                --region $aws_region)
echo "Success!!! VPC ID '$vpc_id' created in '$aws_region' region."

# Naming the VPC
echo "Naming the VPC..."
aws ec2 create-tags --resources $vpc_id --tags "Key=Name,Value=$vpc_name" --region $aws_region
echo "Success!!! VPC ID '$vpc_id' named as '$vpc_name'."

echo "Task-2"
# Create Security Group
echo "Creating Security Group..."
security_group_id=$(aws ec2 create-security-group --group-name $security_group_name \
                --description "Security group - 1" \
                --vpc-id $vpc_id \
                --query 'GroupId' \
                --output text \
                --region $aws_region)
echo "Success!!! Security Group '$security_group_id' created as $security_group_name!"

echo "Task-3"
# Add rules to security group
echo "Adding Inbound Rules..."
aws ec2 authorize-security-group-ingress --group-id $security_group_id \
                --protocol tcp \
                --port 22 \
                --cidr 0.0.0.0/0 \
                --region $aws_region   #ssh Anywhere IPv4
aws ec2 authorize-security-group-ingress --group-id $security_group_id \
                --protocol tcp \
                --port 80 \
                --cidr 0.0.0.0/0 \
                --region $aws_region   #http Anywhere IPv4
aws ec2 authorize-security-group-ingress --group-id $security_group_id \
                --protocol tcp \
                --port 443 \
                --cidr 0.0.0.0/0 \
                --region $aws_region  #https Anywhere IPv4
echo "Success!!! Inbound Rules added for SSH, HTTP & HTTPS types with 22, 80 & 443 Port Range!"

echo "Task-4"
# Create Public Subnet
echo "Creating Public Subnet..."
subnet_public_id_1=$(aws ec2 create-subnet --vpc-id $vpc_id \
                --cidr-block $subnet_public_cidr_1 \
                --availability-zone $subnet_public_zone_1 \
                --query 'Subnet.{SubnetId:SubnetId}' \
                --output text \
                --region $aws_region)
subnet_public_id_2=$(aws ec2 create-subnet --vpc-id $vpc_id \
                --cidr-block $subnet_public_cidr_2 \
                --availability-zone $subnet_public_zone_2 \
                --query 'Subnet.{SubnetId:SubnetId}' \
                --output text \
                --region $aws_region)
subnet_public_id_3=$(aws ec2 create-subnet --vpc-id $vpc_id \
                --cidr-block $subnet_public_cidr_3 \
                --availability-zone $subnet_public_zone_3 \
                --query 'Subnet.{SubnetId:SubnetId}' \
                --output text \
                --region $aws_region)
echo "Success!!! Public Subnet are created!"

# Naming the Public Subnets
echo "Naming the Public Subnets..."
aws ec2 create-tags --resources $subnet_public_id_1 \
                --tags "Key=Name,Value=$subnet_public_name_1" \
                --region $aws_region
aws ec2 create-tags --resources $subnet_public_id_2 \
                --tags "Key=Name,Value=$subnet_public_name_2" \
                --region $aws_region
aws ec2 create-tags --resources $subnet_public_id_3 \
                --tags "Key=Name,Value=$subnet_public_name_3" \
                --region $aws_region
echo "Success!!! Public Subnet 1 '$subnet_public_id_1' named as '$subnet_public_name_1'."
echo "Success!!! Public Subnet 2 '$subnet_public_id_2' named as '$subnet_public_name_2'."
echo "Success!!! Public Subnet 3 '$subnet_public_id_3' named as '$subnet_public_name_3'."

echo "Task-5"
# Create Internet gateway
echo "Creating Internet Gateway..."
internet_gateway_id=$(aws ec2 create-internet-gateway \
                --query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' \
                --output text --region $aws_region)
echo "Success!!! Internet Gateway Created!"

echo "Task-6"
# Attach Internet gateway to your VPC
echo "Attaching Internet gateway to your VPC..."
aws ec2 attach-internet-gateway --vpc-id $vpc_id \
                --internet-gateway-id $internet_gateway_id \
                --region $aws_region
echo "Internet Gateway ID '$internet_gateway_id' attached to VPC ID '$vpc_id'."

# Route Table
route_table_id=$(aws ec2 describe-route-tables \
                --filters "Name=vpc-id,Values=$vpc_id" \
                --query 'RouteTables[].Associations[].RouteTableId' \
                --output text)

echo "Naming Route Table..."
aws ec2 create-tags --resources $route_table_id \
                --tags Key=Name,Value=$route_table_name \
                --region $aws_region
echo "Success!!! Then Name is added to Route Table"

echo "Create a route to internet gateway..."
aws ec2 create-route --route-table-id $route_table_id \
                --destination-cidr-block 0.0.0.0/0 \
                --gateway-id $internet_gateway_id \
                --region $aws_region
echo "Success!!! The Route is added to internet gateway with cidr block 0.0.0.0/0"

echo "Task-7"
echo "Launch an instance ..."
instance_id_1=$(aws ec2 run-instances --image-id $ami_id \
                --instance-type $instance_type \
                --key-name $key_name \
                --security-group-ids $security_group_id \
                --subnet-id $subnet_public_id_2 \
                --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name_1}]" \
                --associate-public-ip-address  \
                --query 'Instances[*].InstanceId' \
                --output text  \
                --region $aws_region \
                --count 1)
# instance_id_2=$(aws ec2 run-instances --image-id $ami_id --instance-type $instance_type --key-name $key_name --security-group-ids $security_group_id --subnet-id $subnet_public_id_2 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name_2}]" --region $aws_region)
# instance_id_3=$(aws ec2 run-instances --image-id $ami_id --instance-type $instance_type --key-name $key_name --security-group-ids $security_group_id --subnet-id $subnet_public_id_3 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name_3}]" --region $aws_region)
echo "Success!!! The $instance_name_1 Instance is created!!!"

echo "Getting Public IP of '$instance_name_1'"
instance_name_1_ip=$(aws ec2 describe-instances --instance-ids $instance_id_1 \
                --query 'Reservations[*].Instances[*].PublicIpAddress' \
                --output text \
                --region $aws_region)
                
echo "Success!!! The Created Instance's Public IP is: '$instance_name_1_ip'"

echo "Sleep 300 min..."
sleep 400
echo "Done sleeping!"
echo "Generate SSH KEYs..."
ssh-keygen
echo "SSH KEYs successfully generated!"
sleep 2
echo "Copy Public KEY to '$instance_name_1_ip'..."
ssh-copy-id ec2-user@$instance_name_1_ip
echo "Public KEY is copied to '$instance_name_1_ip'..."
sleep 2
echo "Copy Jenkins bash file to '$instance_name_1_ip'..."
scp /home/ec2-user/jenkinsRun.sh ec2-user@$instance_name_1_ip:
echo "The Jenkins bash file is copied to '$instance_name_1_ip'!"
sleep 2
echo "Run the Jenkins bash file from '$instance_name_1_ip'..."
ssh ec2-user@$instance_name_1_ip bash /home/ec2-user/jenkinsRun.sh
echo "Succes!!! Jenkins isntallation is completed in '$instance_name_1_ip'..."
echo "Now you can check the Jenkins status from '$instance_name_1_ip'"
echo "Congatulations!!!"