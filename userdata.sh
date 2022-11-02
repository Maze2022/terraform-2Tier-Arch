#!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Terraform Modules:2-Tier</h1>" > var/www/html/index.html

