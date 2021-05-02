+++
title = 'MySQL v8 on Ubuntu'
image = '/images/post/mysql.png'
author = 'Naim'
date = 2019-12-29
description = 'Setting up MySQL v8 on ubuntu'
categories = ["mysql","ubuntu"]
type = 'post'
+++



MySQL is an open-source relational database management system.



Table of Contents
=================

* [MySQL Repository](#mysql-repository)
* [Installing MySQL](#installing-mysql)
    * [Securing MySQL](#securing-mysql)
* [Testing MySQL](#testing-mysql)
* [Create a database](#create-a-database)
* [Create a user](#create-a-user)
    * [Locahost access](#locahost-access)
    * [Anyhost access](#anyhost-access)
* [User privilege](#user-privilege)
    * [Grant all privilege to user](#grant-all-privilege-to-user)
    * [Grant specific database privilege to user](#grant-specific-database-privilege-to-user)
    * [Grant all database readonly permission to user](#grant-all-database-readonly-permission-to-user)
    * [Grant specific database readonly permission to user](#grant-specific-database-readonly-permission-to-user)
    * [Show granted permission](#show-granted-permission)
    * [Drop user](#drop-user)
* [MySQL Config](#mysql-config)
* [Uninstall](#uninstall)
    * [Ubuntu](#ubuntu)
    * [macOS](#macos)
* [Fixing ERROR](#fixing-error)
    * [macOS](#macos-1)





## MySQL Repository

Now we’re going to download the repository.

```shell
cd /tmp && curl -OL https://repo.mysql.com//mysql-apt-config_0.8.13-1_all.deb
```

Now we’re ready to install. Note that in the package installation process, you will be prompted to choose MySQL server version and other components such as cluster, shared client libraries, or the MySQL workbench that you want to configure for installation.

MySQL server version mysql-8.0 will be auto-selected, then scroll down to the last option `Ok` and click `Enter` to finish the configuration and installation of the release package, as shown in the screenshot.

```shell
sudo dpkg -i mysql-apt-config*
```

The package will now finish adding the repository. Refresh your apt package cache to make the new software packages available:

```shell
sudo apt update
```

Let’s also clean up after ourselves and delete the file we downloaded:

```shell
rm mysql-apt-config*
```


## Installing MySQL

Having added the repository and with our package cache freshly updated, we can now use apt to install the latest MySQL server package:

```shell
sudo apt install mysql-server
```


MySQL should now be installed and running. Let’s check using systemctl

```shell
sudo systemctl status mysql
```



#### Securing MySQL

MySQL comes with a command we can use to perform a few security-related updates on our new install. Let’s run it now:

```shell
sudo mysql_secure_installation

# Would you like to setup VALIDATE PASSWORD plugin? N
# Please set the password for root here.
# New password: **********************
# Re-enter new password: **********************
# Remove anonymous users? Y
# Disallow root login remotely? N
# Remove test database and access to it? Y
# Reload privilege tables now? Y

# Success.

# All done!
```


Connect to the MySQL shell as the root user.

```bash
sudo mysql -u root -p
# Enter password
```



Next, check which authentication method each of your MySQL user accounts use with the following command:

```mysql
SELECT user,authentication_string,plugin,host FROM mysql.user;
```



MySQL 8 default authentication plugin is caching_sha2_password. To change root user plugin to mysql_native_password, run the following ALTER USER command. Be sure to change password to a strong password of your choosing:

```mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123123';
```



By default MySQL 8 root user can acccess from only localhost. If you want to access it from any host then run:

```mysql
UPDATE mysql.user SET host='%' WHERE user='root';
```



Set MySQL sever time zone:

```mysql
SET GLOBAL time_zone = '+00:00';
```



Then, run FLUSH PRIVILEGES which tells the server to reload the grant tables and put your new changes into effect:

```mysql
FLUSH PRIVILEGES;
```



Once you confirm this on your own server, you can exit the MySQL shell:

```mysql
exit
```




## Testing MySQL

mysqladmin is a command line administrative client for MySQL. We’ll use it to connect to the server and output some version and status information:

```shell
mysqladmin -u root -p version
```



## Create a database

```mysql
CREATE DATABASE DB_NAME;
```



## Create a user

MySQL 8.0 default authentication plugin is caching_sha2_password rather than mysql_native_password, which is the default method in MySQL 5.7 and prior. But CREATE or ALTER your database user to mysql_native_password.



#### Locahost access

Create user to access database from localhost

```mysql
CREATE USER 'user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'PASSWORD';
```



#### Anyhost access
Create user to access database from any host

```mysql
CREATE USER 'user'@'%' IDENTIFIED WITH mysql_native_password BY 'PASSWORD';
```





## User privilege



#### Grant all privilege to user

```mysql
GRANT ALL PRIVILEGES ON * . * TO 'user'@'localhost' IDENTIFIED BY 'PASSWORD';;
```


#### Grant specific database privilege to user

```mysql
GRANT ALL ON DB_NAME.* TO 'user'@'localhost' IDENTIFIED BY 'PASSWORD';
```



#### Grant all database readonly permission to user

```mysql
GRANT SELECT ON *.* TO 'user'@'localhost' IDENTIFIED BY 'PASSWORD';

```

#### Grant specific database readonly permission to user

```mysql
GRANT SELECT ON DB_NAME.* TO 'user'@'localhost' IDENTIFIED BY 'PASSWORD';
```



#### Show granted permission

```mysql
 SHOW GRANTS FOR 'user'@'localhost';
```



Then, run FLUSH PRIVILEGES which tells the server to reload the grant tables and put your new changes into effect:

```mysql
FLUSH PRIVILEGES;
```


#### Drop user

```shell
drop user username;
```



## MySQL Config

Open mysql config

```shell
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

Add following lines

```text
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
log-error       = /var/log/mysql/error.log
bind-address    = 0.0.0.0
port            = 6969
default_time_zone='+00:00'
```



Restart mysql

```shell
service mysql restart
```



## Uninstall

#### Ubuntu

```bash
sudo apt-get --purge remove mysql-client mysql-server mysql-common && \
sudo apt-get autoremove && \
sudo apt-get autoclean && \
sudo rm -rf /etc/mysql/ && \
sudo rm -rf /var/lib/mysql/
```

#### macOS

```bash
sudo rm -rf /usr/local/Cellar/mysql
brew cleanup
sudo rm -rf /usr/local/var/mysql
brew install mysql
```


## Fixing ERROR

#### macOS

ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)

I tried to kill the PID which is what most posts recommend, but the error remained 

This command did the trick for me, my installed MySQL version is just mysql if you're is like mysql@5.7 then adjust the name on the end of the command.

```bash
sudo chown -R _mysql:mysql /usr/local/var/mysql && sudo brew services restart mysql
```

Another approach is to change MySQL Permissions:

```bash
sudo chown -R _mysql:mysql /usr/local/var/mysql
sudo mysql.server start
```
