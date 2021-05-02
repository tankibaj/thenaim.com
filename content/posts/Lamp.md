+++
title = 'LAMP Stack Installation'
image = '/images/post/lamp.jpg'
author = 'Naim'
date = 2018-06-09
description = 'How to setup LAMP stack'
categories = ["apache","php","mysql","ubuntu"]
type = 'post'
+++


A “LAMP” stack is a group of open-source software that is typically installed together to enable a server to host dynamic websites and web apps.

Table of Contents
=================

* [Apache](#apache)
    * [Virtual Host](#virtual-host)
* [PHP](#php)
    * [Enabling PHP 7\.3 FPM/FastCGI](#enabling-php-73-fpmfastcgi)
* [MySQL](#mysql)

## Apache

The Apache web server is among the most popular web servers in the world. It’s well-documented and has been in wide use for much of the history of the web, which makes it a great default choice for hosting a website.

Install Apache using Debian’s package manager, APT:

```bash
sudo apt update && sudo apt install -y apache2
```

Next, assuming that you have followed the initial server setup instructions by [installing and enabling the UFW firewall](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-debian-10#step-4-—-setting-up-a-basic-firewall), make sure that your firewall allows HTTP and HTTPS traffic.

```bash
sudo ufw app list

#Available applications:
  #Apache
  #Apache Full
  #Apache Secure
  #OpenSSH
```

If you inspect the `Apache Full` profile, it shows that it enables traffic to ports `80` and `443`:

```bash
sudo ufw app info "Apache Full"

#Profile: Apache Full
#Title: Web Server (HTTP,HTTPS)
#Description: Apache v2 is the next generation of the omnipresent Apache web server.

#Ports: 
	#80,443/tcp
```

Allow incoming HTTP and HTTPS traffic for this profile:

```bash
sudo ufw allow in "Apache Full"
```

You can do a spot check right away to verify that everything went as planned by visiting your server’s public IP address in your web browser:

```
http://your_server_ip
```

If you see Apache web page, then your web server is now correctly installed and accessible through your firewall.

If you do not know what your server’s public IP address is, there are a number of ways you can find it. Usually, this is the address you use to connect to your server through SSH.

There are a few different ways to do this from the command line. First, you could use the `iproute2` tools to get your IP address by typing this:

```bash
ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
```

An alternative method is to use the `curl` utility to contact an outside party to tell you how *it* sees your server. This is done by asking a specific server what your IP address is:

```bash
sudo apt install curl
curl http://icanhazip.com
```

#### Virtual Host

By default, Apache serves its content from a directory located at `/var/www/html`, using the configuration contained in `/etc/apache2/sites-available/000-default.conf`. Instead of modifying the default website configuration file, we are going to create a new *virtual host* for testing your PHP environment. Virtual hosts enable us to keep multiple websites hosted on a single Apache server.

Following that, you’ll create a directory structure within `/var/www` for an example website named **your_domain**.

Create the root web directory for **your_domain** as follows:

```bash
sudo mkdir /var/www/your_domain
```

Next, assign current user as root web directory owner and read only permisson to apache www-data group. $USER is environment variable, which should reference your current system user. 

```bash
sudo chown -R $USER /var/www/your_domain
sudo chgrp -R www-data /var/www/your_domain
sudo chmod -R 750 /var/www/your_domain
sudo chmod g+s /var/www/your_domain

# If need apache write permission for a folder. Ex: uploads
sudo chmod g+w /var/www/your_domain/uploads

# To check permission
ls -l
```

Then, open a new configuration file in Apache’s `sites-available` directory using your preferred command-line editor. Here, we’ll use `nano`:

```bash
sudo nano /etc/apache2/sites-available/your_domain.conf
```

This will create a new blank file. Paste in the following bare-bones configuration:

```apache
<VirtualHost *:80>
    ServerName your_domain
    ServerAlias www.your_domain 
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/your_domain
    
    <Directory /var/www/your_domain>
        	Options Indexes FollowSymLinks MultiViews
        	#Options FollowSymLinks # Enable this line if you want to prevent Apache from exposing files and directories to visitors.
					AllowOverride All
					Order deny,allow
					Allow from all
    </Directory>   
    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

You can now use `a2ensite` to enable this virtual host:

```bash
sudo a2ensite your_domain
```

You might want to disable the default website that comes installed with Apache. To disable Apache’s default website, type:

```bash
sudo a2dissite 000-default
```

To make sure your configuration file doesn’t contain syntax errors, you can run:

```bash
sudo apache2ctl configtest
```

Finally, reload Apache so these changes take effect:

```bash
sudo systemctl reload apache2
```

Your new website is now active, but the web root `/var/www/your_domain` is still empty. In the next step, we’ll create a PHP script to test the new setup and confirm that PHP is correctly installed and configured on your server.

## PHP

PHP is the component of your setup that will process code to display dynamic content. It can run scripts, connect to your databases to get information, and hand the processed content over to your web server to display.

PHP 7.3 for Ubuntu and Debian is available from ondrej/php PPA repository. PHP 7.3 stable version has been released with many new features and bug fixes. Add ondrej/php which has PHP 7.3 package and other required PHP extensions.

```bash
sudo apt-get install -y software-properties-common && \
sudo add-apt-repository ppa:ondrej/php && \
sudo apt-get update
```

Once the PPA repository has been added, install php 7.3 on your Ubuntu/Debian.

```bash
sudo apt install -y php7.3 libapache2-mod-php7.3
```

Install common php extensions

```bash
sudo apt install -y php7.3-common php7.3-cli php7.3-fpm php7.3-json php7.3-pdo php7.3-mysql php7.3-zip php7.3-gd php7.3-mbstring php7.3-curl php7.3-xml php7.3-bcmath php7.3-simplexml php7.3-opcache php7.3-memcached php7.3-xmlrpc php7.3-imagick php7.3-recode php7.3-tidy
```

For development environment

```bash
sudo apt install -y php7.3-dev
```

This should install PHP without any problems. We’ll test this in a moment.

In most cases, you will want to modify the way that Apache serves files. Currently, if a user requests a directory from the server, Apache will first look for a file called `index.html`. We want to tell the web server to prefer PHP files over others, so make Apache look for an `index.php` file first.

To do this, type the following command to open the `dir.conf` file in a text editor with root privileges:

```bash
sudo nano /etc/apache2/mods-enabled/dir.conf
```

It will look like this:

```
<IfModule mod_dir.c>
    DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm
</IfModule>
```

Move the PHP index file (highlighted above) to the first position after the `DirectoryIndex` specification, like this:

```
<IfModule mod_dir.c>
    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
```

When you are finished, save and close the file. Now reload Apache’s configuration with:

```bash
sudo systemctl reload apache2
```

You can check on the status of the `apache2` service with `systemctl status`:

```bash
sudo systemctl status apache2
```

```
Smaple Output:

● apache2.service - The Apache HTTP Server
   Loaded: loaded (/lib/systemd/system/apache2.service; enabled; vendor preset: enabled)
  Drop-In: /lib/systemd/system/apache2.service.d
           └─apache2-systemd.conf
   Active: active (running) since Mon 2020-02-03 11:29:44 UTC; 7min ago
  Process: 43038 ExecReload=/usr/sbin/apachectl graceful (code=exited, status=0/SUCCESS)
 Main PID: 28195 (apache2)
    Tasks: 6 (limit: 1017)
   CGroup: /system.slice/apache2.service
           ├─28195 /usr/sbin/apache2 -k start
           ├─43043 /usr/sbin/apache2 -k start
           ├─43044 /usr/sbin/apache2 -k start
           ├─43045 /usr/sbin/apache2 -k start
           ├─43046 /usr/sbin/apache2 -k start
           └─43047 /usr/sbin/apache2 -k start
```

Testing PHP Processing on your Web Server. Create a new file named `info.php` inside your custom web root folder:

```bash
sudo echo "<?php phpinfo();" >> /var/www/your_domain/info.php
```

Now you can test whether your web server is able to correctly display content generated by this PHP script. To try this out, visit this page in your web browser. You’ll need your server’s public IP address again.

The address you will want to visit is:

```
http://your_domain/info.php
```

#### Enabling PHP 7.3 FPM/FastCGI

PHP-FPM is a FastCGI process manager, which maintains a constantly running stock of PHP processes for faster processing of PHP scripts. In combination with the OpCache cache module , PHP-FPM can significantly accelerate PHP applications by a factor of two and more. This noticeably reduces the loading time of PHP-based websites, and also improves the ranking on many search engines. The faster processing of PHP scripts also means that a web server can process more simultaneous page requests, so PHP-FPM is particularly worthwhile for websites with a relatively large number of calls.

Enable FPM in Apache server:

```bash
sudo a2enmod proxy_fcgi setenvif && \
sudo a2enconf php7.3-fpm && \
sudo systemctl restart apache2
```

Modify apache virtual host configuration file:

```bash
sudo nano /etc/apache2/sites-available/your_domain.conf
```

Add following lines in Virtualhost:

```
<FilesMatch \.php$>
			SetHandler "proxy:unix:/var/run/php/php7.2-fpm.sock|fcgi://localhost/"
</FilesMatch>
```

After modification done, apache virtual host configuration file wil look like this:

```apache
<VirtualHost *:80>
    ServerName your_domain
    ServerAlias www.your_domain 
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/your_domain
    

    <Directory /var/www/your_domain>
        Options Indexes FollowSymLinks MultiViews
        #Options FollowSymLinks # Enable this line if you want to prevent Apache from exposing files and directories to visitors.
       AllowOverride All
       Order deny,allow
       Allow from all
    </Directory>
    
    <FilesMatch \.php$>
        SetHandler "proxy:unix:/var/run/php/php7.3-fpm.sock|fcgi://localhost/"
    </FilesMatch>
    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
```

To make sure your configuration file doesn’t contain syntax errors, you can run:

```bash
sudo apache2ctl configtest
```

Finally, reload Apache so these changes take effect:

```bash
sudo systemctl reload apache2
```

You can check FPM status by run:

```bash
systemctl status php7.3-fpm
```

## MySQL

- [MySQL v8](/posts/mysql-v8-ubuntu/)

- [MySQL](/posts/mysql-ubuntu/)