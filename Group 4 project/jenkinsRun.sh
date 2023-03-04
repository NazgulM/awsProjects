#!/bin/bash
echo "Task-8"
echo "Installation of Jenkins ..."
echo " Add the Jenkins repo using the following command:"
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
echo " Import a key file from Jenkins-CI to enable installation from the package:"
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
echo " Install Java:"
sudo amazon-linux-extras install java-openjdk11 -y
echo " Install Jenkins:"
sudo yum install jenkins -y
echo " Enable the Jenkins service to start at boot:"
sudo systemctl enable jenkins
echo " Start Jenkins as a service:"
sudo systemctl start jenkins
echo " You can check the status of the Jenkins service using the command:"
sudo systemctl status jenkins
