# Group-4 Project

```
Please create EC2-Instance named "Project" and perform all your tasks there(for Group3 and Group4):

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

For our Project we created the EC2 instance named "Project" in Ohio Region - us-east-2
From the CLI using the Public IP connect to our Project instance.
Run command:

```
aws configure 
```

For the tasks from 1 to 7, run the bash file fullProject4.sh
After step 7 the execution will sleep for 5 minutes, meanwhile connect to new created ec2-group-4 instance.
Run following commands:

```
sudo passwd ec2-user         #Change password
sudo vi /etc/ssh/sshd_config #Change PasswordAuthentication to YES
sudo systemctl restart sshd  # Restart sshd
```

After sleep execution is completed the jenkinsRun.sh will be executed automatically.
Then we can check status of Jenkins

```
systemctl status jenkins
```

