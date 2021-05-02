+++
title = 'Setting up deprecated PHP version on macOS'
image = '/images/post/php.png'
author = 'Naim'
date = 2019-04-12
description = 'Setting up deprecated PHP Version on macOS'
categories = ["brew","php","macos"]
type = 'post'
+++

Up until the end of March 2018, all PHP related brews were handled by Homebrew/php tab, but that has been deprecated, so now we use what's available in the Homebrew/core package. This should be a better maintained, but is a much less complete, set of packages.



PHP 5.6, PHP 7.0, and PHP 7.1 have been deprecated and removed from Brew because they are out of support, and while it's not recommended for production, there are legitimate reasons to test these unsupported versions in a development environment.

Remember only PHP 7.2 through 7.4 are officially supported by Brew so if you want to install PHP 5.6, PHP 7.0, or PHP 7.1 you will need to add this tap:



```shell
brew tap exolnet/homebrew-deprecated
```



We will proceed by installing various verions of PHP and using a simple script to switch between them as we need. Feel free to exclude any versions you don't want to install.

```
brew install php@5.6
brew install php@7.0
brew install php@7.1
brew install php@7.2
brew install php@7.3
brew install php@7.4
```



The first one will take a little bit of time as it has to install a bunch of brew dependencies. Subsequent PHP versions will install faster. You no longer have to `unlink` each version between installing PHP versions as they are not linked by default.



Also, you may have the need to tweak configuration settings of PHP to your needs. A common thing to change is the memory setting, or the `date.timezone` configuration. The `php.ini` files for each version of PHP are located in the following directories:

```
/usr/local/etc/php/5.6/php.ini
/usr/local/etc/php/7.0/php.ini
/usr/local/etc/php/7.1/php.ini
/usr/local/etc/php/7.2/php.ini
/usr/local/etc/php/7.3/php.ini
/usr/local/etc/php/7.4/php.ini
```



Let's switch back to the first PHP version now:

```shell
brew unlink php@7.4 && brew link --force --overwrite php@7.0
```

xdebug
```shell
$(brew --prefix php@7.3)/bin/pecl install --force xdebug
```



###### PHP Extension

Checl PECL

```bash
ls -al $(which pecl)
ls -al $(which pear)
```

 Install APCU extension

```bash
pecl install apcu
```

