# SSH with mac to my EC2 instance

For this demo, created the EC2 instance with security group with opened inbound rules SSH, HTTP.

Used following commands:
Put my SSH key in folder and cd to that folder

```

ssh ec2-user@ipAddress
It gives the error
Permission denied (publickey,gssapi-keyex,gssapi-with-mic).

ssh -i key_name.pem ec2-user@ipAddress

Second error was: 
WARNING: UNPROTECTED PRIVATE KEY FILE!  

chmod 0400 key_name.pem

ssh -i key_name.pem ec2-user@ipAddress

```
Successfully connected!
