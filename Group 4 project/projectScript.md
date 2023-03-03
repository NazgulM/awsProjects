# Group-4 Project

Group 4: Write Bash Script that creates:

1. VPC named "vpc-group-4" with CIDR block 10.0.0.0/16
2. Security group named "sg-group-4"
3. Open inbound ports 22, 80, 443 for everything in security group "sg-group-4"
4. Create 3 public subnets: 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24 in each availability zones respectively(us-east-2a, us-east-2b, us-east-2c)
5. Create Internet Gateway
6. Attach Internet Gateway to VPC "vpc-group-4"
7. Create EC2 Instance named "ec2-group-4" with security group "sg-group-4"
8. Install Jenkins on EC2 "ec2-group-4"


```
#!/bin/bash

# Variables used in this project
aws_region="us-east-2"
vpc_name="vpc-group-4"
cidr_vpc="10.0.0.0/16"

sg_group_name="sg_group_4"

subnet_public_name_1="ohio-2a"
subnet_public_cidr_1="10.0.1.0/24"
subnet_public_zone_1="us-east-2a"

subnet_public_name_2="ohio-2b"
subnet_public_cidr_2="10.0.2.0/24"
subnet_public_zone_2="us-east-2b"

subnet_public_name_3="ohio-2c"
subnet_public_cidr_3="10.0.3.0/24"
subnet_public_zone_3="us-east-2c"

instance_name="ec2-group-4"
instance_type="t2.micro"
ami_id="ami-0f3c9c466bb525749"
key_name="practice_key"

echo -e "Task-1. Create VPC named "vpc-group-4" with CIDR block 10.0.0.0/16/n Creating VPC..."
vpc_id=$(aws ec2 create-vpc --cidr-block $cidr_vpc --query Vpc.VpcId --output text --region $aws_region)

echo "VPC ID '$vpc_id' created in $aws_region." 

echo "Naming the VPC.."
aws ec2 create-tags --resources $vpc_id --tags "Key=Name,Value=$vpc_name" --region $aws_region

echo "VPC ID '$vpc_id' named as '$vpc_name'"

echo "Task-2 Create security group named sg-group-4"
echo "Creating Security Group .."

sg_id=$(aws ec2 create-security-group --group-name $sg_group_name  --description "Security group -1" --vpc-id $vpc_id --query 'GroupId' --output text --region $aws_region)

echo "Security Group '$sg_id' created as $sg_group_name "

echo "Task-3 Open inbound ports 22 SSH, 80 HTTP, 443 HTTPS  for everything in security group sg-group-4"
echo "Adding inbound Rules .."
aws ec2 authorize-security-group-ingress --group-id $sg_id --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $aws_region
aws ec2 authorize-security-group-ingress --group-id $sg_id --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $aws_region
aws ec2 authorize-security-group-ingress --group-id $sg_id --protocol tcp --port 443 --cidr 0.0.0.0/0 --region $aws_region

echo "Inbound Rules added for SSH, HTTP & HTTPS types with 22, 80 & 443 Port Range"

echo "Task-4 Create 3 public subnets: 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24 in each availability zones respectively(us-east-2a, us-east-2b, us-east-2c)"

echo "Creating public subnets ..."
subnet_public_id_1=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block $subnet_public_cidr_1 --availability-zone $subnet_public_zone_1 --query 'Subnet.{SubnetId:SubnetId}' --output text --region $aws_region)

subnet_public_id_2=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block $subnet_public_cidr_2 --availability-zone $subnet_public_zone_2 --query 'Subnet.{SubnetId:SubnetId}' --output text --region $aws_region)

subnet_public_id_3=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block $subnet_public_cidr_3 --availability-zone $subnet_public_zone_2 --query 'Subnet.{SubnetId:SubnetId}' --output text --region $aws_region)
echo "Subnet Public Id3 are created"

echo "Enabling subnet automatically receives the public address..."
aws ec2 modify-subnet-attribute --subnet-id $subnet_public_id_1 --map-public-ip-on-launch
aws ec2 modify-subnet-attribute --subnet-id $subnet_public_id_2 --map-public-ip-on-launch
aws ec2 modify-subnet-attribute --subnet-id $subnet_public_id_3 --map-public-ip-on-launch
echo "My subnet automatically receives the public address"  

echo "Naming the public subnets .."
aws ec2 create-tags --resources $subnet_public_id_1 --tags "Key=Name,Value=$subnet_public_name_1" --region $aws_region
aws ec2 create-tags --resources $subnet_public_id_2 --tags "Key=Name,Value=$subnet_public_name_2" --region $aws_region
aws ec2 create-tags --resources $subnet_public_id_3 --tags "Key=Name,Value=$subnet_public_name_3" --region $aws_region
echo "Names were given to my subnets"

echo "Task-5 Create internet gateway"
echo "Creating Internet Gateway"
ig_id=$(aws ec2 create-internet-gateway --query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' --output text --region $aws_region)
echo "Internet Gateway is created successfully!"

echo "Task-6 Attach Internet Gateway to your VPC"
echo "Attaching IG.."
aws ec2 attach-internet-gateway --vpc-id $vpc_id --internet-gateway-id $ig_id --region $aws_region
echo "My IG attached to my VPC!"

echo "Task-7 Create EC2 Instance named "ec2-group-4" with security group sg_group_4"

echo "Launch an instance.."
instance_id=$(aws ec2 run-instances --image-id $ami_id \
             --instance-type $instance_type \
             --key-name $key_name \
             --security-group-ids $sg_id \
             --subnet-id    $subnet_public_id_1 \
             --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]" \
             --region $aws_region --query 'Instances[*].InstanceId' \
              --output text) \

echo "ec2-group-4 instance is created"

instance_ip=$(aws ec2 describe-instances --instance-ids $instance_id   --query 'Reservations[*].Instances[*].PublicIpAddress'    --output text --region $aws_region)

# echo "Creating Route Table for new instance"
# route_table_id=$(aws ec2 create-route-table --vpc-id $vpc_id --query 'RouteTable.{RouteTableId:RouteTableId}' --output text --region $aws_region)
# echo "Route Table was created"

# echo "Naming the Route Table.."
# aws ec2 create-tags --resources $route_table_id  --tags Key=Name,Value=$route_table_name
# echo "Name was given to the Route Table"

# echo "Create a route to internet gateway..."
# aws ec2 create-route --route-table-id $route_table_id --destination-cidr-block 0.0.0.0/0 --gateway-id $internet_gateway_id 
# echo "Success! The route added to the internet gateway" 

echo "Connecting to the ec2-group-4 instance..." 
echo "Generate the new private and public keys myNew_key and myNew_key.pub, respectively" 
ssh-keygen -t rsa -f myNew_key 

echo "Waiting for 3 minutes"  
sleep 3m

echo "Authorize the user and push the public key to the instance"
aws ec2-instance-connect send-ssh-public-key --region $aws_region --instance-id $instance_id --availability-zone $subnet_public_zone_1 --instance-os-user ec2-user --ssh-public-key file://myNew_key.pub


ssh -i myNew_key ec2-user@$instance_ip

echo "Open port 8080"
aws ec2 authorize-security-group-ingress --group-id $sg_id --protocol tcp --port 8080 --cidr 0.0.0.0/0 --region $aws_region



echo "Task-8 Install Jenkins on EC2 ec2-group-4"
echo "Installation of Jenkins" 
sudo yum update –y

sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

sudo amazon-linux-extras install java-openjdk11 -y

sudo yum install jenkins -y

sudo systemctl enable jenkins

sudo systemctl start jenkins

sudo systemctl status jenkins

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

```
