+++
title = "Install Composer on MacOS"
image = "/images/post/composer.png"
author = "Naim"
date = 2017-04-15
description = "How to install composer on MacOS"
categories = ["composer", "php"]
type = "post"

+++

The PHP Composer is a package management tool. It removes the hassle of maintaining PHP packages for an application manually. You can easily install all the required packages using Composer. It maintains a list of required packages in a JSON file called composer.json. This tutorial helps you to install and configure PHP composer on macOS operating system.

Table of Contents
=================

* [Prerequisites](#prerequisites)
* [Composer Installation](#composer-installation)
* [Setting path for composer vendors](#setting-path-for-composer-vendors)

#### Prerequisites

- Shell access to a running macOS.
- PHP 5.3 or higher version must be installed.



#### Composer Installation

Download composer.phar binary file from getcomposer.org website. Next, copy this composer.phar file under bin directory to make available anywhere in the system. Also, set the execute permission on file. I have changed the filename from composer.phar to composer for the easy use.

```
curl -sS https://getcomposer.org/installer | php && \
mv composer.phar /usr/local/bin/composer && \
chmod +x /usr/local/bin/composer
```



Run composer command on the command prompt. This will provide you composer version details along with options available with composer command.

```
composer -V
```



Add the `~/.composer/vendor/bin` directory in system's "PATH"

If your PATH is in .zshrc file :

```
echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
```

If your PATH is in .bashrc file :

```
echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```


#### Setting path for composer vendors

###### macOS
```
echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

###### Ubuntu

```
echo 'export PATH="~/.config/composer/vendor/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```