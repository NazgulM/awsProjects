# Creating and Connecting to MYSQL Database

For this practice I have to create database in RDS --> Create Database --> Standard Create --> Templates --> Free Tier --> Give password for the user admin --> Use the default VPC, if you don't have it, please create new VPC default --> for accessing purpose public access it --> Create database

It should take some time for creating the database. For connecting with MYSQL database I use the AWS CLOUDSHELL

![cloud](1.png)

## Task 2

1; Create database -> Standard create -> Engine options MySQL
Templates - > for this project choose Production and modify it to be within the free-tier -> Availability and durability -> for free-tier I am going to use the Single DB instance ->
Use credential as admin give the password -> Instance configuration, size of the underlying EC2 instance -> Now to remain within the free tier, I'm going to use a burstable class. I will include previous generation classes and choose db.t2.micro, which is within the free tier.

Now for storage type, as we run within the free tier,I wanna use a gp2 type of volume, which is lower performance -> 20 GB of allocated storage -> enable storage autoscaling which will automatically increase the size of the EBS volume in case we are starting to near a threshold. Maximum amount of storage in case enable autoscaling, let's say 100 GB. So I'm going to say don't connect to an EC2 compute resource. Therefore  have to deploy in a specified VPC and then we have to specify a subnet group and then whether or not we want public access
to the database. So I'm going to say yes because I want to access this database from my own computer. I'm going to enter what I have right here on port 3306. The user is admin and the password for me was password.
And then the initial database is mydb, as I entered it from before. Let's click on Test and the connection is successful.
If it's not successful, please have a look whether or not your database was set to be a public database number one,
and number two, have a look at your security group settings
to make sure that your IP is allowed in. So let's save this and connect your database. And now I am connected into my database directly to mydb which was the database that was created. So CREATE TABLE mytable, and then just a name of VARCHAR 20 and first name of VARCHAR 20. So it's just a very quick statement, Execute this. So this is how you would use a RDS database with MySQL, So back in here, my RDS database is fully managed. Other things we can do that are worthy are to create a read replica directly from this database so we can create a read replica.And then this read replica would allow us to have more read capacity for our database.
