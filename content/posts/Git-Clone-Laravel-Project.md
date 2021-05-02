+++
title = 'Necessary Steps After Clone a Laravel Project'
image = '/images/post/laravel.png'
author = 'Naim'
date = 2017-05-13
description = 'Necessary Steps After Clone a Laravel Project'
categories = ["Laravel"]
type = 'post'
+++

Table of Contents
=================

* [Environmental Config File](#environmental-config-file)
* [Install Dependencies](#install-dependencies)
* [Generate Your App Key](#generate-your-app-key)
* [Config cache](#config-cache)
* [Permission (optional)](#permission-optional)



#### Environmental Config File

Sometime project creator merge all config options into one file to speed up the website. Its called config cache. Run following command to clear the config cache.

```
php artisan config:clear
```

All system configuration variables are stored in a single .env file in your project's root. To get started, copy over the .env.example file to a new .env file:

```
cp .env.example .env
```
The first part of your .env file covers basic application settings. And the next section in the .env asks you about your database settings. 


#### Install Dependencies

Composer is a package manager for PHP that allows us to manage the dependencies for the various vendor packages.
Linux / OSX:

```
cd <install-dir>
curl -sS https://getcomposer.org/installer | php
php composer.phar install --no-dev --prefer-source
```

For global composer installations:

```
cd <install-dir>
composer install --no-dev --prefer-source
```

#### Generate Your App Key
Once you've Downloaded, set up Configuration in .env file, and Installed Dependencies, Next need to set an app key. The easiest way to do this is via the artisans command:
```
php artisan key:generate
```

#### Config cache
After setup .env file and composer To speed up the website. Make config cache.

```
 php artisan config:cache
```


#### Permission (optional)
```
sudo chown -R www-data: storage/
sudo chown -R www-data: public/
```
