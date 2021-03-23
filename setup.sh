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

systemctl restart httpd
systemctl restart mariadb

firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

hostname -I

mkdir -p /var/www/example.com/public_html
mkdir -p /var/www/example.com/log
chown -R $USER:$USER /var/www/example.com/public_html

chmod -R 755 /var/www


sed -i "s/^<html>
  <head>
    <title>Welcome to Example.com!</title>
  </head>
  <body>
    <h1>Success! The example.com virtual host is working!</h1>
  </body>
</html>" /var/www/example.com/html/index.html

mkdir /etc/httpd/sites-available /etc/httpd/sites-enabled
sed -i "s/^IncludeOptional sites-enabled/*.conf/g" /etc/httpd/conf/httpd.conf

sed i "s/^<VirtualHost *:80>
    ServerName www.example.com
    ServerAlias example.com
    DocumentRoot /var/www/example.com/public_html
    ErrorLog /var/www/example.com/log/error.log
    CustomLog /var/www/example.com/log/requests.log combined
</VirtualHost>/g" /etc/httpd/sites-available/example.com.conf

ln -s /etc/httpd/sites-available/example.com.conf /etc/httpd/sites-enabled/example.com.conf
systemctl restart httpd
