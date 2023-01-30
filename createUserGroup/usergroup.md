# Create Users and User Group

![alt](/createUserGroup/assets/1.png)

![alt](/createUserGroup/assets/2.png)

After creating users developer1 and developer2 let's create User group Developer_Group, add users and attach policy - AWS Cloud9Administrator policy

![alt](/createUserGroup/assets/3.png)

![alt](/createUserGroup/assets/4.png)

And after creating the group I can see json file with policies

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloud9:*",
                "iam:GetUser",
                "iam:ListUsers",
                "ec2:DescribeVpcs",
                "ec2:DescribeSubnets"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": "cloud9.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": "ssm:StartSession",
            "Resource": "arn:aws:ec2:*:*:instance/*",
            "Condition": {
                "StringLike": {
                    "ssm:resourceTag/aws:cloud9:environment": "*"
                },
                "StringEquals": {
                    "aws:CalledViaFirst": "cloud9.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:StartSession"
            ],
            "Resource": [
                "arn:aws:ssm:*:*:document/*"
            ]
        }
    ]
}
```

