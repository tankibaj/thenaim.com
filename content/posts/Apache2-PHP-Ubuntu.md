+++
title = "Install Apache PHP on Ubuntu"
image = "/images/post/apache.jpg"
author = "Naim"
date = 2017-12-08
description = "How to install Apache PHP on Ubuntu"
categories = ["apache", "php", "ubuntu"]
type = "post"

+++

In this article I will show how to install apache and php on ubuntu.

  * [Install PHP](#install-php)
  * [Configure Apache2](#configure-apache2)
  * [Configure php date time zone](#configure-php-date-time-zone)
* [line 941: uncomment and add your timezone](#line-941-uncomment-and-add-your-timezone)
  * [Configure PHP\-FPM (Optional)](#configure-php-fpm-optional)
  * [Test php](#test-php)
* [Optional For PHP](#optional-for-php)
  * [Show the List of Installed Packages on Ubuntu or Debian](#show-the-list-of-installed-packages-on-ubuntu-or-debian)


## Install PHP

```
sudo apt -y install php php7.2-cgi libapache2-mod-php7.2 php7.2-common php7.2-pear php7.2-mbstring php7.2-xml php7.2-gd php7.2-opcache php7.2-fpm php7.2-zip php7.2-curl php7.2-json php7.2-bcmath php7.2-ctype php7.2-pdo php7.2-tokenizer php7.2*-mcrypt php7.2-readline php7.2-cli
```

## Configure Apache2

```
sudo a2enconf php7.2-cgi
```


## Configure php date time zone
Edit php.ini to setup time zone

```
sudo nano /etc/php/7.2/apache2/php.ini
```
# line 941: uncomment and add your timezone

`date.timezone = "Europe/Berlin"`



## Configure PHP-FPM (Optional)
Open VirtualHost to Edit

```
sudo nano /etc/apache2/sites-available/000-default.conf
```
Add into <VirtualHost> - </VirtualHost>

```
<FilesMatch \.php$>
	SetHandler "proxy:unix:/var/run/php/php7.2-fpm.sock|fcgi://localhost/"
</FilesMatch>
```

Enabling proxy_fcgi and setenvif

```
sudo a2enmod proxy_fcgi setenvif
```
Enabling conf php7.2-fpm

```
a2enconf php7.2-fpm
```

Configure php fpm date time zone

Open current loaded php.ini 

```
sudo nano /etc/php/7.2/fpm/php.ini 
```

Change following line

`date.timezone = "Europe/Berlin"`

Restart and Reload php7.2-fpm and apache2

```
systemctl reload apache2
sudo systemctl restart php7.2-fpm apache2
```

## Test php
Create [phpinfo] in Virtualhost's web-root:

```
echo '<?php phpinfo(); ?>' > /var/www/html/info.php
```
Hit: http://localhost/info.php


## Optional For PHP

The command we need to use is dpkg –get-selections, which will give us a list of all the currently installed packages.

```
dpkg --get-selections
```
The full list can be long and unwieldy, so it’s much easier to filter through grep to get results for the exact package you need. For instance, I wanted to see which php packages I had already installed through apt-get:

```
dpkg --get-selections | grep php
```

For extra credit, you can find the locations of the files within a package from the list by using the dpkg -L command, such as:

```
dpkg -L php7.2-gd
```
