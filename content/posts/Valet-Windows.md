+++
title = 'Valet on Windows'
image = '/images/post/valet.png'
author = 'Naim'
date = 2019-03-04
description = 'Setting up Valet on Windows'
categories = ["valet","windows"]
type = 'post'
+++


Valet is a Laravel development environment for macOS minimalists. But today with the help of a third party package, we can install Valet on Windows. No Vagrant, no `/etc/hosts` file. You can even share your sites publicly using local tunnels.


#### Install PHP
If your system doesn’t have PHP, make sure to [install the latest version of PHP](http://windows.php.net/download) before installing Valet.

#### Installation Composer
You must have installed [Composer](https://getcomposer.org/download) to install Valet.


#### Valet installation
- Finally, require the package valet. Also, make sure that your system isn’t running any programs that bind port 80 (like Apache or Nginx). And run the commands shown below as Administrator.

```bash
composer global require cretueusebiu/valet-windows
```
- Install valet

```bash
valet install
```

- We need to configure `127.0.0.1` as IPv4 Preferred DNS server and `::1` as IPv6 Preferred DNS server.

![Imgur](https://i.imgur.com/xdiwo9a.png)

- Once Valet is installed, try pinging any `*.test` domain on your terminal using a command such as `ping foobar.test`. If Valet is installed correctly you should see this domain responding on  127.0.0.1.


- Create a new directory on your pc by running something like mkdir `~/sites`. Next,  `cd ~/sites` and run `valet park`. This command will register your current working directory as a path that Valet should search for sites.

- Next, create a new Laravel site within this directory: `laravel new blog`.

- Open http://blog.test in your browser.


#### Sharing Sites
Valet even includes a command to share your local sites with the world. No additional software installation is required once Valet is installed.

To share a site, navigate to the site's directory in your terminal and run the `valet share` command. A publicly accessible URL will be inserted into your clipboard and is ready to paste directly into your browser. That's it.

To stop sharing your site, hit `Control + C` to cancel the process.


#### Other Valet Commands

`valet forget` Run this command from a "parked" directory to remove it from the parked directory list.

`valet log`	View a list of logs which are written by Valet's services.

`valet paths`	View all of your "parked" paths.

`valet restart`	Restart the Valet daemon.

`valet start`	Start the Valet daemon.

`valet stop`	Stop the Valet daemon.

`valet uninstall`	Uninstall the Valet daemon.
