#!/bin/bash
# Descriptoin:  Install Httpd server
# Author: Omda
# Issue of date: 26-06-2025
# Modify of date: 26-06-2025


sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd.service
sudo systemctl enable httpd.service