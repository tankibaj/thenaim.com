+++
title = "Laravel Passport Example Project"
image = "/images/post/laravel.png"
author = "Naim"
date = 2019-06-20
description = "Laravel Passport Project"
categories = ["laravel"]
type = "post"

+++

Laravel Passport provides a full OAuth2 server implementation for your Laravel application in a matter of minutes. This is a laravel passport example project.

Table of Contents
=================

* [Environmental Config File](#environmental-config-file)
* [Install Dependencies](#install-dependencies)
* [Generate Your App Key](#generate-your-app-key)
* [Config cache](#config-cache)
* [Permission (optional)](#permission-optional)

### Git Clone
```
git clone https://github.com/tankibaj/Laravel-RESTful-API.git
```

### Go to project root directory
```
cd <project-dir>
```

### Environmental Config File

Sometime project creator merge all config options into one file to speed up the website. Its called config cache. Run following command to clear the config cache.

```
php artisan config:clear
```

All system configuration variables are stored in a single .env file in your project's root. To get started, copy over the .env.example file to a new .env file:

```
cp .env.example .env
```
The first part of your .env file covers basic application settings. And the next section in the .env asks you about your database settings.

### Install Dependencies

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

### Generate Your App Key
Once you've Downloaded, set up Configuration in .env file, and Installed Dependencies, Next need to set an app key. The easiest way to do this is via the artisans command:
```
php artisan key:generate
```

### Config cache
After setup .env file and composer To speed up the website. Make config cache.

```
 php artisan config:cache
```


### Migration

```
php artisan migrate
```

### Install Passport Key

```
php artisan passport:install --force
```
