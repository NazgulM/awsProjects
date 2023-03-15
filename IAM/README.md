# EC2 instances attach role

For this purpose it was created the role --> Create Role -> AWS Service -> Common use Cases -> EC2 -> Add Permissions-> IAMReadOnlyAccess-> give the role name --> Create Role

Without attaching the role for EC2 instance it cannot see the aws iam list-users

You can see
this notification in AWS CloudShell

```
Unable to locate credentials. You can configure credentials by running "aws configure".
```
