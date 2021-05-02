+++
title = "Valet on Ubuntu"
image = "/images/post/valet.png"
author = "Naim"
date = 2019-03-05
description = "Valet on Ubuntu"
categories = ["Valet", "Ubuntu"]
type = "post"

+++


Valet is a Laravel development environment for macOS minimalists. But today with the help of a third party package, we can install Valet on Ubuntu. No Vagrant, no `/etc/hosts` file. You can even share your sites publicly using local tunnels.

Also, make sure that your system isn’t running any programs that bind port 80 (like Apache or Nginx).

#### Dependencies Installation

```
sudo apt-get install libnss3-tools jq xsel zip unzip curl git
```

#### PHP Installation
```
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update && sudo apt upgrade
sudo apt -y install php7.3 php7.3-cgi php7.3-common php7.3-mbstring php7.3-mysql php7.3-xml php7.3-gd php7.3-opcache php7.3-fpm php7.3-zip php7.3-curl php7.3-json php7.3-bcmath php7.3-readline php7.3-cli
```

#### Composer Installation
- Command-line installation

```
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
```


- Composer Executable Globally. You can place the Composer PHAR anywhere you wish. If you put it in a directory that is part of your PATH, you can access it globally. On Unix systems you can even make it executable and invoke it without directly using the php interpreter.

```
sudo mv composer.phar /usr/local/bin/composer
```

- [Make laravel globally](https://github.com/tankibaj/docs/blob/master/composer-path-global.md)


#### Valet Installation
- Finally, require the package valet

```
composer global require cpriego/valet-linux
```


- Install valet

```
valet install
```


- Once Valet is installed, try pinging any `*.test` domain on your terminal using a command such as ping `foobar.test`. If Valet is installed correctly you should see this domain responding on  127.0.0.1.


- Create a new directory on your pc by running something like `mkdir ~/sites`. Next,  `cd ~/sites` and run `valet park`. This command will register your current working directory as a path that Valet should search for sites.

- Next, create a new Laravel site within this directory: `laravel new blog`.

- Open http://blog.test in your browser.


##### Sharing Sites
Valet even includes a command to share your local sites with the world. No additional software installation is required once Valet is installed.

To share a site, navigate to the site's directory in your terminal and run the `valet share` command. A publicly accessible URL will be inserted into your clipboard and is ready to paste directly into your browser. That's it.

To stop sharing your site, hit `Control + C` to cancel the process.

##### Other Valet Commands

`valet forget` Run this command from a "parked" directory to remove it from the parked directory list.

`valet log`	View a list of logs which are written by Valet's services.

`valet paths`	View all of your "parked" paths.

`valet restart`	Restart the Valet daemon.

`valet start`	Start the Valet daemon.

`valet stop`	Stop the Valet daemon.

`valet uninstall`	Uninstall the Valet daemon.