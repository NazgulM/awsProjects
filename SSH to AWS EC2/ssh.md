# Connecting through ssh to your EC2 instance

Create EC2 instance using laptop-key pair copied from cat .ssh/id_rsa.pub

When type in your local CLI

```
ssh ec2-user@privateIp
```

It will connect in your terminal

Next practice with IAM
Add users --> give the name to the user --> Attach policies directly --> AdministratorAccess --> Create User

Click to the user --> Create access key --> Copy the secret key and access key

Go to terminal

```
aws configure
AWS Access Key ID [None]: AKIA5TVZHG3KRYBW43KB
AWS Secret Access Key [None]: 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
Default region name [None]: us-east-2
Default output format [None]: 
```

```
cd .aws
ls
config credentials
cat credentials
```

Next bash script for this instance
First specifying the region, instance type,ami_id

```
#!/bin/bash

# Set the region to Ohio
region="us-east-2"

# Set the instance type and AMI ID
instance_type="t2.micro"
ami_id="ami-0cc87e5027adcdca8"

# Set the key pair name and security group ID
key_name="my-mac-key"
# Launch the instance
aws ec2 run-instances --region $region --image-id $ami_id --instance-type $instance_type --key-name $key_name
```

This bash script creates all of these through this scripts, here is the security groups is default.
Assign Security Group through bash script

```
#!/bin/bash

# Set the region to Ohio
region="us-east-2"

# Set the instance type and AMI ID
instance_type="t2.micro"
ami_id="ami-0cc87e5027adcdca8"

# Security group for the instance
security_group_id="sg-0c4978168ea187376"



# Set the key pair name and security group ID
key_name="my-mac-key"
# Launch the instance
aws ec2 run-instances --region $region --image-id $ami_id --instance-type $instance_type --key-name $key_name --security-group-ids $security_group_id
```

It should create new vm (instance) with this exact security group from launch-wizard-1

Next practice 
```
#!/bin/bash

# Set the region to Ohio
region="us-east-2"

# Set the instance type and AMI ID
instance_type="t2.micro"
ami_id="ami-0cc87e5027adcdca8"

# Set the key pair name and security group ID
key_name="my-mac-key"
security_group_id="sg-0c4978168ea187376"
instance_name="hello"
# Launch the instance
aws ec2 run-instances --region $region --image-id $ami_id --instance-type $instance_type --key-name $key_name --security-group-ids $security_group_id --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]"
~  
```

Instance name should be hello, create script step by step, with a small steps, stopping code, assign the name, security groups, cloud gateways etc.

Create new bash script vpc.sh

