+++
title = 'Advance Nginx and PHP 7.3'
image = '/images/post/nginx.png'
author = 'Naim'
date = 2020-03-24
description = 'Advance Nginx and PHP'
categories = ["nginx","php","ubuntu"]
type = 'post'
+++


This article describes how to install nginx (http, https, basic auth) and php (php-fpm).



Table of Contents
=================

* [Nginx Installation](#nginx-installation)
    * [Install nginx package](#install-nginx-package)
    * [Firewall configure](#firewall-configure)
    * [Server root directory setup](#server-root-directory-setup)
    * [Tweaking Nginx](#tweaking-nginx)
* [PHP 7\.3 Installation](#php-73-installation)
    * [Add PHP 7\.3 PPA](#add-php-73-ppa)
    * [Install PHP 7\.3 Extensions](#install-php-73-extensions)
* [Configuring Nginx to Use the PHP Processor](#configuring-nginx-to-use-the-php-processor)
    * [HTTP 80](#http-80)
    * [HTTPS 443](#https-443)
    * [Test PHP Nginx](#test-php-nginx)
* [Permissions](#permissions)
    * [Define the requirements](#define-the-requirements)
    * [Single user](#single-user)
    * [Group of users](#group-of-users)
* [Disabling accesing server by ip address](#disabling-accesing-server-by-ip-address)
* [Nginx Basic Auth](#nginx-basic-auth)
    * [Introduction](#introduction)
    * [Prerequisites](#prerequisites)
    * [Creating a Password File](#creating-a-password-file)
    * [Configuring NGINX and NGINX Plus for HTTP Basic Authentication](#configuring-nginx-and-nginx-plus-for-http-basic-authentication)

## Nginx Installation
In order to display web pages to our site visitors, we are going to employ Nginx, a modern, efficient web server.

##### Install nginx package

```shell
sudo apt update
sudo apt install nginx
```
After accepting the procedure, apt will install Nginx and any required dependencies to your server.



##### Firewall configure

After install Nginx, the firewall software needs to be adjusted to allow access to the service. Nginx registers itself as a service with **ufw** upon installation, making it straightforward to allow Nginx access.

List the application configurations that **ufw** knows how to work with by typing:

```shell
sudo ufw app list
```

You should get a listing of the application profiles:

```text
Output:

Available applications:
  Nginx Full
  Nginx HTTP
  Nginx HTTPS
  OpenSSH
```
As you can see, there are three profiles available for Nginx:

- Nginx Full: This profile opens both port 80 (normal, unencrypted web traffic) and port 443 (TLS/SSL encrypted traffic).


- Nginx HTTP: This profile opens only port 80 (normal, unencrypted web traffic).


- Nginx HTTPS: This profile opens only port 443 (TLS/SSL encrypted traffic).



It is recommended that you enable the most restrictive profile that will still allow the traffic you’ve configured. Since we will configure SSL for our server in this guide, we will only need to allow traffic on port 443.

You can enable this by typing:

```shell
sudo ufw allow 'Nginx HTTPS'
```

You can verify the change by typing:

```shell
sudo ufw status
```

You should see HTTP traffic allowed in the displayed output:

```text
Output:

Status: active

To                         Action      From
--                         ------      ----
OpenSSH                    ALLOW       Anywhere                  
Nginx HTTP                 ALLOW       Anywhere                  
OpenSSH (v6)               ALLOW       Anywhere (v6)             
Nginx HTTP (v6)            ALLOW       Anywhere (v6)
```



##### Server root directory setup

Nginx on Ubuntu 18.04 has one server block enabled by default that is configured to serve documents out of a directory at **/var/www/html**. While this works well for a single site, it can become unwieldy if you are hosting multiple sites. Instead of modifying **/var/www/html**, let’s create a directory structure within **/var/www** for our **example.com** site, leaving **/var/www/html** in place as the default directory to be served if a client request doesn’t match any other sites.

Create the directory for **example.com** as follows, using the **-p** flag to create any necessary parent directories:

```shell
sudo mkdir /var/www/your_domain
```
Next, assign current user as root web directory owner and read only permisson to nginx www-data group. $USER is environment variable, which should reference your current system user.

```shell
sudo chown -R $USER /var/www/your_domain
sudo chgrp -R www-data /var/www/your_domain
sudo chmod -R 750 /var/www/your_domain
sudo chmod g+s /var/www/your_domain

# If need nginx write permission for a folder. Ex: uploads
sudo chmod g+w /var/www/your_domain/uploads

# To check permission
ls -l
```



##### Tweaking Nginx

To avoid a possible hash bucket memory problem that can arise from adding additional server names, it is necessary to adjust a single value in the `/etc/nginx/nginx.conf` file. Open the file:

```shell
sudo nano /etc/nginx/nginx.conf
```
Find the **server_names_hash_bucket_size** directive and remove the **#** symbol to uncomment the line:

```text
…
http {
    …
    server_names_hash_bucket_size 64;
    …
}
…
```

Next, test to make sure that there are no syntax errors in any of your Nginx files:

```shell
sudo nginx -t
```

Save and close the file when you are finished.

If there aren’t any problems, restart Nginx to enable your changes:

```shell
sudo systemctl reload nginx
```



## PHP 7.3 Installation

PHP 7.3 for Ubuntu and Debian is available from ondrej/php PPA repository. PHP 7.3 stable version has been released with many new features and bug fixes.



##### Add PHP 7.3 PPA

Add ondrej/php which has PHP 7.3 package and other required PHP extensions.


```shell
sudo add-apt-repository ppa:ondrej/php && sudo apt-get update
```
This PPA can be added to your system manually by copying the lines below and adding them to your system’s software sources.



##### Install PHP 7.3 Extensions

Once the PPA repository has been added, install php 7.3 on your Ubuntu/Debian.

```shell
sudo apt install php7.3 php7.3-common php7.3-cli php7.3-fpm php7.3-json php7.3-mysql php7.3-zip php7.3-gd  php7.3-mbstring php7.3-curl php7.3-xml php7.3-bcmath php7.3-json
```

Check version installed

```shell
php -v
```

Check php configuration files
```shell
php --ini
```

## Configuring Nginx to Use the PHP Processor
You now have Nginx installed to serve your pages. However, you still don’t have anything that can generate dynamic content. This is where PHP comes into play.

Since Nginx does not contain native PHP processing like some other web servers, you will need to install php-fpm, which stands for “fastCGI process manager”. We will tell Nginx to pass PHP requests to this software for processing.

This is done on the server block level (server blocks are similar to Apache’s virtual hosts). To do this, open a new server block configuration file within the `/etc/nginx/sites-available/` directory. In this example, the new server block configuration file is named `example.com`, although you can name yours whatever you’d like.

By editing a new server block configuration file, rather than editing the default one, you’ll be able to easily restore the default configuration if you ever need to.

Add the following content, which was taken and slightly modified from the default server block configuration file, to your new server block configuration file:

##### HTTP 80

Now, Create new server block for you domain
```shell
sudo nano /etc/nginx/sites-available/your_domain
```

```nginx
server {
        listen 80;
        root /var/www/your_domain;
        index index.php index.html index.htm index.nginx-debian.html;
        server_name example.com;

        location / {
                try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
        }

        location ~ /\.ht {
                deny all;
        }
}
```

For Laravel App host: [https://laravel.com/docs/master/deployment#nginx](https://laravel.com/docs/master/deployment#nginx)

```nginx
server {
    listen 80;
    server_name example.com;
    root /var/www/your_domain/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    index index.html index.htm index.php;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
```



##### HTTPS 443

Create your_domain name directory for certificate and private key

```shell
sudo mkdir -p /etc/nginx/ssl/your_domain
```

Next, add certificate, private key and authenticated origin pulls certificate (This tutorial we are using cloudflare ssl).

```shell
sudo nano /etc/nginx/ssl/your_domain/cert.crt
sudo nano /etc/nginx/ssl/your_domain/key.pem
sudo wget --no-check-certificate 'https://support.cloudflare.com/hc/en-us/article_attachments/360044928032/origin-pull-ca.pem' -O /etc/nginx/ssl/your_domain/cloudflare.crt
```

Now, Create new server block for you domain
```shell
sudo nano /etc/nginx/sites-available/your_domain
```

Rewrite extension less:

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name example.com www.example.com;
    return 302 https://$server_name$request_uri;
}

server {

    # SSL configuration

    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    ssl_certificate         /etc/nginx/ssl/your_domain/cert.crt;
    ssl_certificate_key     /etc/nginx/ssl/your_domain/key.pem;
    ssl_client_certificate  /etc/nginx/ssl/your_domain/cloudflare.crt;
    ssl_verify_client on;

    server_name example.com www.example.com;
    root /var/www/your_domain;

    charset utf-8;
    
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";


    location / {
         try_files $uri $uri/ @extensionless-php;
	 index index.html index.htm index.php;
    }
    

    location ~ \.php$ {
         include snippets/fastcgi-php.conf;
         fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
         fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
         include fastcgi_params;
    }

    location @extensionless-php {
         rewrite ^(.*)$ $1.php last;
     }
}
```



For Laravel App host: [https://laravel.com/docs/master/deployment#nginx](https://laravel.com/docs/master/deployment#nginx)


```nginx
server {
    listen 80;
    listen [::]:80;
    server_name example.com www.example.com;
    return 302 https://$server_name$request_uri;
}

server {

    # SSL configuration

    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    ssl_certificate         /etc/nginx/ssl/your_domain/cert.crt;
    ssl_certificate_key     /etc/nginx/ssl/your_domain/key.pem;
    ssl_client_certificate  /etc/nginx/ssl/your_domain/cloudflare.crt;
    ssl_verify_client on;

    server_name example.com www.example.com;

    root /var/www/your_domain/public;
    index index.php index.html index.htm;

    charset utf-8;
    
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";


    location / {
            try_files $uri $uri/ /index.php?$query_string;
    }
    
    error_page 404 /index.php;

    location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
            fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
            include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
            deny all;
    }
}
```


Here’s what each of these directives and location blocks do:


- `listen` — Defines what port Nginx will listen on. In this case, it will listen on port 80, the default port for HTTP.

- `root` — Defines the document root where the files served by the website are stored.

- `index` — Configures Nginx to prioritize serving files named index.php when an index file is requested, if they’re available.

- `server_name` — Defines which server block should be used for a given request to your server. Point this directive to your server’s domain name or public IP address.

- `location /` — The first location block includes a try_files directive, which checks for the existence of files matching a URI request. If Nginx cannot find the appropriate file, it will return a 404 error.

- `location ~ \.php$` — This location block handles the actual PHP processing by pointing Nginx to the fastcgi-php.conf configuration file and the php7.2-fpm.sock file, which declares what socket is associated with php-fpm.

- `location ~ /\.ht` — The last location block deals with .htaccess files, which Nginx does not process. By adding the deny all directive, if any .htaccess files happen to find their way into the document root they will not be served to visitors.

After adding this content, save and close the file. Enable your new server block by creating a symbolic link from your new server block configuration file (in the `/etc/nginx/sites-available/` directory) to the `/etc/nginx/sites-enabled/` directory:

```shell
sudo ln -s /etc/nginx/sites-available/your_domain /etc/nginx/sites-enabled/
```

Then, unlink the default configuration file from the /sites-enabled/ directory:

```shell
sudo unlink /etc/nginx/sites-enabled/default
```

Test your new configuration file for syntax errors by typing:

```shell
sudo nginx -t
```

If any errors are reported, go back and recheck your file before continuing.

When you are ready, reload Nginx to make the necessary changes:

```shell
sudo systemctl reload nginx
```

##### Test PHP Nginx

Your nginx and php are ready now. You can test it to validate that Nginx can correctly hand .php files off to the PHP processor.

To do this, use your text editor to create a test PHP file called info.php in your document root:

```shell
sudo nano /var/www/example.com/html/info.php
```

Enter the following lines into the new file. This is valid PHP code that will return information about your server:

```php
<?php
phpinfo();
```

When you are finished, save and close the file.

Now, you can visit this page in your web browser by visiting your server’s domain name or public IP address followed by `/info.php`:

```url
http://your_server_domain_or_IP/info.php
```

You should see a web page that has been generated by PHP with information about your server:


![img](https://i.imgur.com/aHq0LwZ.png)


If you see a page that looks like this, you’ve set up PHP processing with Nginx successfully.

For now, remove the file by typing:

```shell
sudo rm /var/www/your_domain/info.php
```



## Permissions



##### Define the requirements

- Developers need read/write access to files so they can update the website.
- Developers need read/write/execute on directories so they can browse around.
- Apache needs read access to files and interpreted scripts.
- Apache needs read/execute access to serveable directories.
- Apache needs read/write/execute access to directories for uploaded content.



##### Single user

If only one user is responsible for maintaining the site, set them as the user owner on the website directory and give the user full rwx permissions. Apache still needs access so that it can serve the files, so set www-data as the group owner and give the group r-x permissions.

In your case, `Naim`, whose username might be `naim`, is the only user who maintains `thenaim.com`:

```bash
sudo chown -R naim thenaim.com/
sudo chgrp -R www-data thenaim.com/
sudo chmod -R 750 thenaim.com/
sudo chmod g+s thenaim.com/
```

If you have folders that need to be writable by Apache, you can just modify the permission values for the group owner so that www-data has write access.

```bash
sudo chmod g+w uploads
```

Now, All the directories and sub-directories to 750 and All the files change to 640

```bash
sudo find /var/www/project -type d -exec chmod 750 {} \;
sudo find /var/www/project -type f -exec chmod 640 {} \;
```



##### Group of users

If more than one user is responsible for maintaining the site, you will need to create a group to use for assigning permissions. It's good practice to create a separate group for each website, and name the group after that website.

```bash
sudo groupadd dev-thenaim
sudo usermod -a -G dev-thenaim naim
sudo usermod -a -G dev-thenaim roni
```

In the previous example, we used the group owner to give privileges to Apache, but now that is used for the developers group. Since the user owner isn't useful to us anymore, setting it to root is a simple way to ensure that no privileges are leaked. Apache still needs access, so we give read access to the rest of the world.

```bash
sudo chown -R root thenaim.com
sudo chgrp -R dev-thenaim thenaim.com
sudo chmod -R 775 thenaim.com
sudo chmod g+s thenaim.com
```

If you have folders that need to be writable by Apache, you can make Apache either the user owner or the group owner. Either way, it will have all the access it needs. Personally, I prefer to make it the user owner so that the developers can still browse and modify the contents of upload folders.

```bash
sudo chown -R www-data uploads
```

Although this is a common approach, there is a downside. Since every other user on the system has the same privileges to your website as Apache does, it's easy for other users to browse your site and read files that may contain secret data, such as your configuration files. 

You can have your cake and eat it too. This can be further improved upon. It's perfectly legal for the owner to have less privileges than the group, so instead of wasting the user owner by assigning it to root, we can make Apache the user owner on the directories and files on your website. This is a reversal of the single maintainer scenario, but it works equally well.

```bash
sudo chown -R www-data thenaim.com
sudo chgrp -R dev-thenaim thenaim.com
sudo chmod -R 570 thenaim.com
sudo chmod g+s thenaim.com
```

If you have folders that need to be writable by Apache, you can just modify the permission values for the user owner so that www-data has write access

```bash
sudo chmod u+w uploads
```

One thing to be careful about with this solution is that the user owner of new files will match the creator instead of being set to www-data. So any new files you create won't be readable by Apache until you chown them.



## Disabling accesing server by ip address
Now, Create new server block
```shell
sudo nano /etc/nginx/sites-available/disable_server_ip
```

```nginx
server {
 listen 80;
 server_name 51.79.156.52;
 return 503;
}
```

Enable Site
```bash
sudo ln -s /etc/nginx/sites-available/disable_server_ip /etc/nginx/sites-enabled/
````


## Nginx Basic Auth

##### Introduction

You can restrict access to your website or some parts of it by implementing a username/password authentication. Usernames and passwords are taken from a file created and populated by a password file creation tool, for example, `apache2-utils`.

HTTP Basic authentication can also be combined with other access restriction methods, for example restricting access by [IP address](https://docs.nginx.com/nginx/admin-guide/security-controls/blacklisting-ip-addresses/) or [geographical location](https://docs.nginx.com/nginx/admin-guide/security-controls/controlling-access-by-geoip/).



##### Prerequisites

- NGINX Plus or NGINX Open Source
- Password file creation utility such as `apache2-utils` (Debian, Ubuntu) or `httpd-tools` (RHEL/CentOS/Oracle Linux).



##### Creating a Password File

To create username-password pairs, use a password file creation utility, for example, `apache2-utils` or `httpd-tools`

1. Verify that `apache2-utils` (Debian, Ubuntu) or `httpd-tools` (RHEL/CentOS/Oracle Linux) is installed.

2. Create a password file and a first user. Run the `htpasswd` utility with the `-c` flag (to create a new file), the file pathname as the first argument, and the username as the second argument:

   ```bash
   sudo htpasswd -c /etc/nginx/.htpasswd user1
   ```

   Press Enter and type the password for **user1** at the prompts.

3. Create additional user-password pairs. Omit the `-c` flag because the file already exists:

   ```bash
   sudo htpasswd /etc/nginx/.htpasswd user2
   ```

4. You can confirm that the file contains paired usernames and encrypted passwords:

   ```bash
   cat /etc/apache2/.htpasswd
   
   # user1:$apr1$/woC1jnP$KAh0SsVn5qeSMjTtn0E9Q0
   # user2:$apr1$QdR8fNLT$vbCEEzDj7LyqCMyNpSoBh/
   # user3:$apr1$Mr5A0e.U$0j39Hp5FfxRkneklXaMrr/
   ```



##### Configuring NGINX and NGINX Plus for HTTP Basic Authentication

```nginx
    location /gui {

      # Auth
      satisfy all;
  
      allow 51.79.156.52;
      deny  all;

      auth_basic           “AdministratorArea”;
      auth_basic_user_file /etc/nginx/.htpasswd;
  
  	  ........
   }
```



HTTP basic authentication can be effectively combined with access restriction by IP address. You can implement at least two scenarios:

- a user must be both authenticated and have a valid IP address
- a user must be either authenticated, or have a valid IP address

1. Allow or deny access from particular IP addresses with the [`allow`](https://nginx.org/en/docs/http/ngx_http_access_module.html#allow) and [`deny`](https://nginx.org/en/docs/http/ngx_http_access_module.html#deny) directives:

   ```
   location /api {
       #...
       deny  192.168.1.2;
       allow 192.168.1.1/24;
       allow 127.0.0.1;
       deny  all;
   }
   ```

   Access will be granted only for the `192.168.1.1/24` network excluding the `192.168.1.2` address. Note that the `allow` and `deny` directives will be applied in the order they are defined.

2. Combine restriction by IP and HTTP authentication with the [`satisfy`](https://nginx.org/en/docs/http/ngx_http_core_module.html#satisfy) directive. If you set the directive to to `all`, access is granted if a client satisfies both conditions. If you set the directive to `any`, access is granted if if a client satisfies at least one condition:

   ```
   location /api {
       #...
       satisfy all;    
   
       deny  192.168.1.2;
       allow 192.168.1.1/24;
       allow 127.0.0.1;
       deny  all;
   
       auth_basic           "AdministratorArea";
       auth_basic_user_file conf/htpasswd;
   }
   ```
