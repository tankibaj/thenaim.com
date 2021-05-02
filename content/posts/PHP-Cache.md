+++
title = 'Memcached for PHP'
image = '/images/post/php.png'
author = 'Naim'
date = 2018-04-29
description = 'Setting up Memcached for PHP'
categories = ["memcached","php"]
type = 'post'
+++

Memcached is a free & open-source, high-performance, distributed memory object caching system, generic in nature, but intended for use in speeding up dynamic web applications by alleviating database load. Its simple design promotes quick deployment, ease of development, and solves many problems facing large data caches.

Table of Contents
=================

* [Install Memcached](#install-memcached)
* [Configuring Memcached](#configuring-memcached)
* [Memcached PHP Extension](#memcached-php-extension)
* [Check Memcached Installation](#check-memcached-installation)
* [Opcache](#opcache)


#### Install Memcached

```bash
sudo apt install memcached libmemcached-tools
```

Next, check the status by issuing the commands below:

```bash
sudo systemctl status memcached
```

Enable the service to start on boot by issuing the command below:

```bash
sudo systemctl enable memcached.service
```



#### Configuring Memcached

The core configuration file for Memcached is the /etc/memcached.conf file. By default, Memcached uses 11211 as the port number. You can also change this to any value of your choice.

```bash
sudo nano /etc/memcached.conf
```

By default, Memcached listens on the server's local IP address. You can change this if you want it to listen on a different IP by making changes in the conf file.

After saving and exiting, ensure to restart Memcached for our changes to be enforced.

```bash
sudo systemctl restart memcached
```



#### Memcached PHP Extension

```bash
sudo apt install php-memcached
```



#### Check Memcached Installation

To check our Memcached installation, we can create a info.php to verify.

```bash
sudo nano /var/www/html/info.php
```

Enter the following lines into the new file. This is valid PHP code that will return information about your server:

```php
<?php
phpinfo();
```

Now, hit info.php from the browser and search for the `memcached`.



#### Opcache

OPcache improves PHP performance by storing precompiled script bytecode in shared memory, thereby removing the need for PHP to load and parse scripts on each request.

Open php.ini and change following settings

```bash
sudo nano /etc/php/7.3/fpm/php.ini
```

```ini
opcache.enable=1
opcache.enable_cli=1
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.memory_consumption=128
opcache.save_comments=1
opcache.revalidate_freq=1
```

Restart FPM

```bash
sudo systemctl restart php7.3-fpm.service
```

Restart nginx

```bash
sudo systemctl restart nginx
```

