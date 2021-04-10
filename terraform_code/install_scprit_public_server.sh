#!/bin/bash
#scrpit run
#install java8
sudo apt update
sudo apt install openjdk-8-jdk openjdk-8-jre -y

#install jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install jenkins -y

#install ansible
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible
