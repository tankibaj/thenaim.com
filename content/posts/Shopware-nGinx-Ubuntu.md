+++
title = 'Shopware on Ubuntu'
image = '/images/post/ubuntu.png'
author = 'Naim'
date = 2020-01-19
description = 'Setting up Shopware on Ubuntu'
categories = ["shopware","ubuntu"]
type = 'post'
+++


Shopware is an open source eCommerce platform for online businesses. This guide will show you how to install Shopware Community Edition (CE) on a fresh Ubuntu 18.04 LTS server instance.

Table of Contents
=================

* [Requirements](#requirements)
* [Before you begin](#before-you-begin)
* [Install PHP](#install-php)
* [Install IonCube Loader](#install-ioncube-loader)
* [Install MySQL and setup the database](#install-mysql-and-setup-the-database)
* [Install and configure Nginx](#install-and-configure-nginx)
* [Install Shopware](#install-shopware)
* [Existing Shopware Clone or Zip](#existing-shopware-clone-or-zip)


## Requirements
Minimum requirements of Shopware are:

* PHP version 5.6.4 or above with the following extensions:
 * ctype
 * curl
 * dom
 * hash
 * iconv
 * gd (with freetype and libjpeg)
 * json
 * mbstring
 * OpenSSL
 * session
 * SimpleXML
 * xml
 * zip
 * zlib
 * PDO/MySQL
* Nginx or Apache with <code>mod_rewrite</code> enabled. This guide will use Nginx.
* MySQL version 5.5.0 or above
* IonCube Loader version 5.0 optional, but recommended

## Before you begin
Check the Ubuntu version.
```bash
lsb_release -ds
```
Create a new non-root user account with sudo access and switch to it.
NOTE: Replace tankibaj with your username.
```bash
adduser shopware --gecos "Shop Ware"
usermod -aG sudo shopware
su - shopware
```
Set up the timezone.
```bash
sudo dpkg-reconfigure tzdata
```
Ensure that your system is up to date.
```bash
sudo apt update && sudo apt upgrade -y
```
Install unzip and curl.
```bash
sudo apt install -y unzip curl
```

## Install PHP
Install PHP 7.3 and required PHP extensions.
```bash
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt install -y php7.3 php7.3-cli php7.3-fpm php7.3-common php7.3-mysql php7.3-curl php7.3-json php7.3-zip php7.3-gd php7.3-xml php7.3-mbstring php7.3-opcache php7.3-apcu
```
Check the version.
```bash
php --version
```
## Install IonCube Loader
```bash
cd /tmp && wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
```
Extract the loader.
```bash
tar xfz ioncube_loaders_lin_*.gz
```
Find the PHP extensions directory on the system by running the commands below.
```bash
php -i | grep extension_dir
# extension_dir => /usr/lib/php/20180731 => /usr/lib/php/20180731
```
Copy the ionCube Loader into the PHP extensions directory.
```bash
sudo cp /tmp/ioncube/ioncube_loader_lin_7.3.so /usr/lib/php/20180731
```
Include the loader via PHP configuration.
```bash
sudo nano /etc/php/7.3/fpm/php.ini
```
Then, add a line in the file to include ionCube loader. It can be anywhere in the file below the [PHP] line.
```ini
zend_extension = /usr/lib/php/20180731/ioncube_loader_lin_7.3.so
```
Save the file and restart PHP-FPM.
```bash
sudo systemctl restart php7.3-fpm.service
```
## Install MySQL and setup the database
Install MySQL.
```bash
cd /tmp && curl -OL https://repo.mysql.com//mysql-apt-config_0.8.13-1_all.deb
sudo dpkg -i mysql-apt-config* && sudo apt update
rm mysql-apt-config*
sudo apt install mysql-server
sudo systemctl status mysql
```
Check the version.
```bash
mysql --version && sudo mysqld --version
```
Run mysql_secure installation to improve MySQL security and set the password for the MySQL root user.
```bash
sudo mysql_secure_installation

# Would you like to setup VALIDATE PASSWORD plugin? N
# Please set the password for root here.
# New password: **********************
# Re-enter new password: **********************
# Remove anonymous users? Y
# Disallow root login remotely? Y
# Remove test database and access to it? Y
# Reload privilege tables now? Y

# Success.

# All done!
```
Connect to the MySQL shell as the root user.
```bash
sudo mysql -u root -p
# Enter password
```
Create an empty MySQL database and user for Shopware, and remember the credentials.
```sql
CREATE DATABASE shopwaredb;
CREATE USER 'shopware'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
GRANT ALL ON shopwaredb.* TO 'shopware';
FLUSH PRIVILEGES;
EXIT;
```
## Install and configure Nginx

Install Nginx

```bash
sudo apt install -y nginx
```

Check the version

```bash
sudo nginx -v
# nginx version: nginx/1.14.0 (Ubuntu)
```

Run `sudo nano /etc/nginx/sites-available/shopware.conf` and configure Nginx for Shopware.

```nginx
server {
    listen 80;
    listen [::]:80;

    server_name example.com; # Check this
    root /var/www/shopware; # Check this

    index shopware.php index.php;

    location / {
        try_files $uri $uri/ /shopware.php$is_args$args;
    }

    location /recovery/install {
      index index.php;
      try_files $uri /recovery/install/index.php$is_args$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.3-fpm.sock; # Check this
    }
}
```

Activate the new `shopware.conf` configuration by linking the file to the `sites-enabled` directory.

```bash
sudo ln -s /etc/nginx/sites-available/shopware.conf /etc/nginx/sites-enabled/
```

Test the configuration

```bash
sudo nginx -t
```

Reload Nginx

```bash
sudo systemctl reload nginx.service
```

## Install Shopware

Create a document root directory

```bash
sudo mkdir -p /var/www/shopware
```

Change ownership of the `/var/www/shopware` directory to `shopware`

```bash
sudo chown -R shopware:shopware /var/www/shopware
```

Download the [latest release of Shopware](https://www.shopware.com/en/download/).

```bash
cd /var/www/shopware
wget https://releases.shopware.com/install_5.6.4_3540d53b7727442cde5287b669c7d3b94f8a07c7.zip -O shopware.zip
unzip shopware.zip
rm shopware.zip
```

**NOTE:** *Update the download link in the command above if there is a newer release.*

Change ownership of the `/var/www/shopware` directory to `www-data`.

```bash
sudo chown -R www-data:www-data /var/www/shopware
```

Increase `memory_limit = 256M` and `upload_max_filesize = 6M`, and set `allow_url_fopen = On` if it is not already set in the `/etc/php/7.3/fpm/php.ini` file.

```bash
sudo nano /etc/php/7.3/fpm/php.ini
```

After making changes in the `/etc/php/7.3/fpm/php.ini` file, reload `php7.3-fpm.service`

```bash
sudo systemctl reload php7.3-fpm.service
```

Open your domain/IP in the web browser and follow the installation wizard. The backend of Shopware is located at `/backend` example: `http://example.com/backend`.

You have successfully installed Shopware.



## Existing Shopware Clone or Zip

Unzip or Clone Shopware project. 

Enable debug mode from config.php

```php
<?php
ini_set('log_errors', 1);
ini_set('error_log', __DIR__.'/php-error.log');
return [
    'db' => [
        'username' => 'root',
        'password' => '123',
        'dbname' => 'shop',
        'host' => 'localhost',
        'port' => '3306',
    ],

	'front' => [
        'showException' => true,
      'throwExceptions' => true,
      'noErrorHandler' => true,
         ],


 'httpcache' => [
        'debug' => true
    ],

    'phpsettings' => [
        'display_errors' => 1,
    ],
];
```

Change project directory permission.

```bash
sudo chown -R naim /var/www/shopware/
sudo chgrp -R www-data /var/www/shopware/
sudo chmod -R 775 /var/www/shopware/
sudo chmod g+s /var/www/shopware/
```

Change all the directories to 775

```bash
sudo find /var/www/shopware -type d -exec chmod 775 {} \;
```

Change all the files to 644

```php
sudo find /var/www/shopware -type f -exec chmod 775 {} \;
```

Change following directories to `0755`

```bash
sudo chmod -R 775 /var/www/shopware/var/
sudo chmod -R 775 /var/www/shopware/web/
sudo chmod -R 775 /var/www/shopware/files/
sudo chmod -R 775 /var/www/shopware/media/
sudo chmod -R 775 /var/www/shopware/engine/Shopware/Plugins/Community/
```

Change following directories permission so webserver can write

```bash
sudo chmod g+w /var/www/shopware/var/cache/
sudo chmod g+w /var/www/shopware/var/log/
```

Clear the cache on console

```bash
cd ./bin
php console sw:cache:clear
```

Create new admin user

```bash
cd ./bin
php console sw:admin:create
```

