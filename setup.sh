#!/bin/bash
#=====================================#
#                                     #
#           Centos 7 Server           #
#                                     #
#=====================================#

yum install epel-release
yum update -y

setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config
yum install -y httpd
yum install -y mariadb-server
