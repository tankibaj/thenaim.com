+++
title = 'Valet on macOS'
image = '/images/post/valet.png'
author = 'Naim'
date = 2019-03-07
description = 'Setting up Valet on macOS'
categories = ["valet","macos"]
type = 'post'
+++


Valet is a Laravel development environment for Mac minimalists. No Vagrant, no `/etc/hosts` file. You can even share your sites publicly using local tunnels.

Table of Contents
=================

* [Installation](#installation)
    * [Using Another Domain](#using-another-domain)
    * [Database](#database)
    * [PHP Versions](#php-versions)
* [Upgrading](#upgrading)
* [Serving Sites](#serving-sites)
    * [The park Command](#the-park-command)
    * [The link Command](#the-link-command)
* [Securing Sites With TLS](#securing-sites-with-tls)
* [Sharing Sites](#sharing-sites)
    * [Sharing Sites Via Ngrok](#sharing-sites-via-ngrok)
    * [Sharing Sites On Your Local Network](#sharing-sites-on-your-local-network)

Laravel Valet configures your Mac to always run [Nginx](https://www.nginx.com/) in the background when your machine starts. Then, using [DnsMasq](https://en.wikipedia.org/wiki/Dnsmasq), Valet proxies all requests on the `*.test` domain to point to sites installed on your local machine.

In other words, a blazing fast Laravel development environment that uses roughly 7 MB of RAM. Valet isn't a complete replacement for Vagrant or Homestead, but provides a great alternative if you want flexible basics, prefer extreme speed, or are working on a machine with a limited amount of RAM.


Out of the box, Valet support includes, but is not limited to:

- [Laravel](https://laravel.com/)
- [Lumen](https://lumen.laravel.com/)
- [Bedrock](https://roots.io/bedrock/)
- [CakePHP 3](https://cakephp.org/)
- [Concrete5](https://www.concrete5.org/)
- [Contao](https://contao.org/en/)
- [Craft](https://craftcms.com/)
- [Drupal](https://www.drupal.org/)
- [Jigsaw](https://jigsaw.tighten.co/)
- [Joomla](https://www.joomla.org/)
- [Katana](https://github.com/themsaid/katana)
- [Kirby](https://getkirby.com/)
- [Magento](https://magento.com/)
- [OctoberCMS](https://octobercms.com/)
- [Sculpin](https://sculpin.io/)
- [Slim](https://www.slimframework.com/)
- [Statamic](https://statamic.com/)
- Static HTML
- [Symfony](https://symfony.com/)
- [WordPress](https://wordpress.org/)
- [Zend](https://framework.zend.com/)

However, you may extend Valet with your own [custom drivers](https://laravel.com/docs/6.x/valet#custom-valet-drivers).



## Installation

**Valet requires macOS and [Homebrew](https://brew.sh/). Before installation, you should make sure that no other programs such as Apache or Nginx are binding to your local machine's port 80.**

- Install or update [Homebrew](https://brew.sh/) to the latest version using `brew update`.
- Install PHP 7.4 using Homebrew via `brew install php`
- Install MySQL 8.0 using Homebrew via `brew install mysql`
- Install [Composer](https://github.com/tankibaj/Docs/blob/master/Composer-MacOS.md)
- Install Valet with Composer via `composer global require laravel/valet`. Make sure the `~/.composer/vendor/bin` directory is in your system's "PATH".
- Run the `valet install` command. This will configure and install Valet and DnsMasq, and register Valet's daemon to launch when your system starts.



Once Valet is installed, try pinging any `*.test` domain on your terminal using a command such as `ping foobar.test`. If Valet is installed correctly you should see this domain responding on `127.0.0.1`.

Valet will automatically start its daemon each time your machine boots. There is no need to run `valet start` or `valet install` ever again once the initial Valet installation is complete.



##### Using Another Domain

By default, Valet serves your projects using the `.test` TLD. If you'd like to use another domain, you can do so using the `valet tld tld-name` command.



For example, if you'd like to use `.app` instead of `.test`, run `valet tld app` and Valet will start serving your projects at `*.app` automatically.



##### Database

If you need a database, try MySQL by running `brew install mysql@5.7` on your command line. Once MySQL has been installed, you may start it using the `brew services start mysql@5.7` command. You can then connect to the database at `127.0.0.1` using the `root` username and an empty string for the password.



##### PHP Versions

Valet allows you to switch PHP versions using the `valet use php@version` command. Valet will install the specified PHP version via Brew if it is not already installed:

```php
valet use php@7.2

valet use php
```

Note: Valet only serves one PHP version at a time, even if you have multiple PHP versions installed.



## Upgrading

You may update your Valet installation using the `composer global update` command in your terminal. After upgrading, it is good practice to run the `valet install` command so Valet can make additional upgrades to your configuration files if necessary.



## Serving Sites

Once Valet is installed, you're ready to start serving sites. Valet provides two commands to help you serve your Laravel sites: `park` and `link`.



##### The `park` Command

- Create a new directory on your Mac by running something like `mkdir ~/Sites`. Next, `cd ~/Sites` and run `valet park`. This command will register your current working directory as a path that Valet should search for sites.
- Next, create a new Laravel site within this directory: `laravel new blog`.
- Open `http://blog.test` in your browser.

**That's all there is to it.** Now, any Laravel project you create within your "parked" directory will automatically be served using the `http://folder-name.test` convention.



##### The `link` Command

The `link` command may also be used to serve your Laravel sites. This command is useful if you want to serve a single site in a directory and not the entire directory.

- To use the command, navigate to one of your projects and run `valet link app-name` in your terminal. Valet will create a symbolic link in `~/.config/valet/Sites` which points to your current working directory.
- After running the `link` command, you can access the site in your browser at `http://app-name.test`.

To see a listing of all of your linked directories, run the `valet links` command. You may use `valet unlink app-name` to destroy the symbolic link. You can use valet link to serve the same project from multiple (sub)domains. To add a subdomain or another domain to your project run valet link subdomain.app-name from the project folder.



## Securing Sites With TLS

By default, Valet serves sites over plain HTTP. However, if you would like to serve a site over encrypted TLS using HTTP/2, use the `secure` command. For example, if your site is being served by Valet on the `laravel.test` domain, you should run the following command to secure it:

```php
valet secure laravel
```

To "unsecure" a site and revert back to serving its traffic over plain HTTP, use the `unsecure` command. Like the `secure` command, this command accepts the host name that you wish to unsecure:

```php
valet unsecure laravel
```



## Sharing Sites

Valet even includes a command to share your local sites with the world, providing an easy way to test your site on mobile devices or share it with team members and clients. No additional software installation is required once Valet is installed.



##### Sharing Sites Via Ngrok

To share a site, navigate to the site's directory in your terminal and run the `valet share` command. A publicly accessible URL will be inserted into your clipboard and is ready to paste directly into your browser or share with your team.

To stop sharing your site, hit `Control + C` to cancel the process.

You may pass additional parameters to the share command, such as `valet share --region=eu`. For more information, consult the [ngrok documentation](https://ngrok.com/docs).



##### Sharing Sites On Your Local Network

Valet restricts incoming traffic to the internal `127.0.0.1` interface by default. This way your development machine isn't exposed to security risks from the Internet.



If you wish to allow other devices on your local network to access the Valet sites on your machine via your machine's IP address (eg: `192.168.1.10/app-name.test`), you will need to manually edit the appropriate Nginx configuration file for that site to remove the restriction on the `listen` directive by removing the the `127.0.0.1:` prefix on the directive for ports 80 and 443.



If you have not run `valet secure` on the project, you can open up network access for all non-HTTPS sites by editing the `/usr/local/etc/nginx/valet/valet.conf` file. However, if you're serving the project site over HTTPS (you have run `valet secure` for the site) then you should edit the `~/.config/valet/Nginx/app-name.test` file.



Once you have updated your Nginx configuration, run the `valet restart` command to apply the configuration changes.

