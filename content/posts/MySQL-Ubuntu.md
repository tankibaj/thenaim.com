+++
title = 'MySQL on Ubuntu 18.04'
image = '/images/post/mysql.png'
author = 'Naim'
date = 2018-08-01
description = 'How to install MySQL on Ubuntu 18.04'
categories = ["mysql", "ubuntu"]
type = 'post'
+++


MySQL is an open-source relational database management system.

Table of Contents
=================

* [MySQL](#mysql)
* [phpMyAdmin](#phpmyadmin)
* [Uninstall MySQL](#uninstall-mysql)


## MySQL
Use apt to acquire and install this software:

```bash
sudo apt update
sudo apt install mysql-server
```

When the installation is complete, run a simple security script that comes pre-installed with MySQL which will remove some dangerous defaults and lock down access to your database system. Start the interactive script by running:

```bash
sudo mysql_secure_installation
```

Open up the MySQL prompt from your terminal:

```bash
sudo mysql -u root -p
```

Next, check which authentication method each of your MySQL user accounts use with the following command:

`SELECT user,authentication_string,plugin,host FROM mysql.user;`


In this example, you can see that the root user does in fact authenticate using the auth_socket plugin. To configure the root account to authenticate with a password, run the following ALTER USER command. Be sure to change password to a strong password of your choosing:

`ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123123';`


Then, run FLUSH PRIVILEGES which tells the server to reload the grant tables and put your new changes into effect:

`FLUSH PRIVILEGES;`

Once you confirm this on your own server, you can exit the MySQL shell:

`exit`



##  phpMyAdmin

To get started, we will install phpMyAdmin from the default Ubuntu repositories.
  
  ```bash
sudo apt install phpmyadmin php-mbstring php-gettext
  ```

The installation process adds the phpMyAdmin Apache configuration file into the /etc/apache2/conf-enabled/ directory, where it is read automatically. The only thing you need to do is explicitly enable the mbstring PHP extension, which you can do by typing:
  
  ```bash
  sudo phpenmod mbstring
  ```

Afterwards, restart Apache for your changes to be recognized:
  
  ```bash
  sudo systemctl restart apache2
  ```

Adjusting User Authentication and Privileges, To do this, open up the MySQL prompt from your terminal:
  
  ```bash
  sudo mysql -u root -p
  update mysql.user set plugin='' where user='root';
  flush privileges;
  exit
  ```



## Uninstall MySQL

```bash
sudo dpkg-reconfigure mysql-server-N.N
sudo apt-get --purge remove mysql-server mysql-common mysql-client
```
(where N.N is the MySql Server version)
