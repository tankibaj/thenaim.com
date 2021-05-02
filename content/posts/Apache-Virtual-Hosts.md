+++
title = "Apache Virtual Host Config"
image = "/images/post/apache.jpg"
author = "Naim"
date = 2017-01-07
description = "Apache Virtual Host Config"
categories = ["apache", "ubuntu"]
type = "post"

+++

Apache was one of the first servers to support IP-based virtual hosts right out of the box. In this article I will show you how to setup apache virtual host.

* [Install Apache2](#install-apache2)
* [Configure Apache2](#configure-apache2)
* [Virtual Hosts](#virtual-hosts)
* [Adjust the Firewall to Allow Web Traffic Ubuntu](#adjust-the-firewall-to-allow-web-traffic-ubuntu)
* [How To Find your Server's Public IP Address](#how-to-find-your-servers-public-ip-address)
----------------


#### Install Apache2

```bash
apt -y install apache2
```

#### Configure Apache2
- Enable Apache mod_rewrite module

```bash
sudo a2enmod rewrite
```

- Edit security.conf
	
```bash
nano /etc/apache2/conf-enabled/security.conf
```
line 25: change
`ServerTokens Prod`


#### Virtual Hosts

- Create the Directory Structure
For our sites, we're going to make our directories like this:

```bash
sudo mkdir -p /var/www/example
sudo mkdir -p /var/www/test

```


Grant Permissions
Now we have the directory structure for our files, but they are owned by our root user. If we want our regular user to be able to modify files in our web directories, we can change the ownership by doing this:

```bash
sudo chown -R $USER:$USER /var/www/example
sudo chown -R $USER:$USER /var/www/test

```

We should also modify our permissions a little bit to ensure that read access is permitted to the general web directory and all of the files and folders it contains so that pages can be served correctly:

```bash
sudo chmod -R 755 /var/www
sudo chown -R www-data: /var/www/test
sudo chown -R www-data: /var/www/example
```


- Create the First Virtual Host File
Virtual host files are the files that specify the actual configuration of our virtual hosts and dictate how the Apache web server will respond to various domain requests.

Apache comes with a default virtual host file called 000-default.conf that we can use as a jumping off point. We are going to copy it over to create a virtual host file for each of our domains.

We will start with one domain, configure it, copy it for our second domain, and then make the few further adjustments needed. The default Ubuntu configuration requires that each virtual host file end in .conf.

```bash
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/example.com.conf
```

Open the new file in your editor with root privileges:

```bash
sudo nano /etc/apache2/sites-available/example.com.conf
```

Edit Following lines in VirtualHost:

```
ServerAdmin admin@example.com
ServerName example.com
ServerAlias www.example.com
DocumentRoot /var/www/example
<Directory /var/www/example>
  AllowOverride All
</Directory>
```

Or remove all lines and paste following:

```
<VirtualHost *:80>
    ServerAdmin admin@example.com
    ServerName example.com
    ServerAlias www.example.com
    DocumentRoot /var/www/example
    <Directory /var/www/example>
        	AllowOverride All
    </Directory>    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
Save and close the file when you are finished.


- Create the Second Virtual Host File
Copy First Virtual Host and Customize for Second Domain

```bash
sudo cp /etc/apache2/sites-available/example.com.conf /etc/apache2/sites-available/test.com.conf
```

Open the new file in your editor with root privileges:

```bash
sudo nano /etc/apache2/sites-available/test.com.conf
```

Edit Following lines in VirtualHost:

```
ServerAdmin admin@test.com
ServerName test.com
ServerAlias www.test.com
DocumentRoot /var/www/test
<Directory /var/www/test>
  AllowOverride All
</Directory>  
```

Or remove all lines and paste following:

```
<VirtualHost *:80>
    ServerAdmin admin@test.com
    ServerName test.com
    ServerAlias www.test.com
    DocumentRoot /var/www/test
    <Directory /var/www/test>
    		AllowOverride All
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
Save and close the file when you are finished.


- Enable the New Virtual Host Files
Now that we have created our virtual host files, we must enable them. Apache includes some tools that allow us to do this.

We can use the a2ensite tool to enable each of our sites like this:

```bash
sudo a2ensite example.com.conf
sudo a2ensite test.com.conf
```

Next, disable the default site defined in 000-default.conf: (Optional)

```bash
sudo a2dissite 000-default.conf
```
Restart Apache2
When you are finished, you need to restart Apache to make these changes take effect:

```bash
sudo systemctl restart apache2
```
In other documentation, you may also see an example using the service command:

```bash
sudo service apache2 restart
```


- Set Up Local Hosts File (Optional)
If you haven't been using actual domain names that you own to test this procedure and have been using some example domains instead, you can at least test the functionality of this process by temporarily modifying the hosts file on your local computer.

This will intercept any requests for the domains that you configured and point them to your VPS server, just as the DNS system would do if you were using registered domains. This will only work from your computer though, and is simply useful for testing purposes.

Make sure you are operating on your local computer for these steps and not your VPS server. You will need to know the computer's administrative password or otherwise be a member of the administrative group.

If you are on a Mac or Linux computer, edit your local file with administrative privileges by typing:

```bash
sudo nano /etc/hosts
```

The details that you need to add are the public IP address of your VPS server followed by the domain you want to use to reach that VPS.

For the domains that I used in this guide, assuming that my VPS IP address is 111.111.111.111, I could add the following lines to the bottom of my hosts file:

```
127.0.0.1   localhost
127.0.1.1   my-macbook
111.111.111.111 example.com
111.111.111.111 test.com
```


#### Adjust the Firewall to Allow Web Traffic Ubuntu
Next, assuming that you have followed the initial server setup instructions and enabled the UFW firewall, make sure that your firewall allows HTTP and HTTPS traffic. You can check that UFW has an application profile for Apache like so:

```bash
sudo ufw app list
```

Output:

```
Available applications:
  Apache
  Apache Full
  Apache Secure
```

If you look at the Apache Full profile, it should show that it enables traffic to ports 80 and 443:

```bash
sudo ufw app info "Apache Full"
```

Output:

```
Profile: Apache Full
Title: Web Server (HTTP,HTTPS)
Description: Apache v2 is the next generation of the omnipresent Apache web
server.

Ports:
  80,443/tcp
```

Allow incoming HTTP and HTTPS traffic for this profile:


```bash
sudo ufw allow in "Apache Full"
```


#### How To Find your Server's Public IP Address
There are a few different ways to do this from the command line. First, you could use the iproute2 tools to get your IP address by typing this:

```bash
ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
```



An alternative method is to use the curl utility to contact an outside party to tell you how it sees your server. This is done by asking a specific server what your IP address is:

```bash
sudo apt install curl
curl http://icanhazip.com
curl https://canhazip.com/more
```
