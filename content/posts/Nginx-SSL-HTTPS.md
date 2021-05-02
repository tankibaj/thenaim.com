+++
title = 'Setting up Nginx HTTPS Server'
image = '/images/post/nginx.png'
author = 'Naim'
date = 2018-02-16
description = 'Setting up Nginx HTTPS Server'
categories = ["nginx", "ssl"]
type = 'post'
+++


This article describes how to configure an HTTPS server on NGINX.

Table of Contents
=================

* [Step 1 — Generating an Origin CA TLS Certificate](#step-1--generating-an-origin-ca-tls-certificate)
* [Step 2 – Installing Nginx](#step-2--installing-nginx)
* [Step 2 — Installing the Origin CA certificate in Nginx](#step-2--installing-the-origin-ca-certificate-in-nginx)
* [Step 4 — Setting Up Authenticated Origin Pulls](#step-4--setting-up-authenticated-origin-pulls)
* [Logs](#logs)

## Step 1 — Generating an Origin CA TLS Certificate
The Cloudflare Origin CA lets you generate a free TLS certificate signed by Cloudflare to install on your Nginx server. By using the Cloudflare generated TLS certificate you can secure the connection between Cloudflare’s servers and your Nginx server.

To generate a certificate with Origin CA, navigate to the **SSL/TLS** section of your Cloudflare dashboard. From there, click on the **Create Certificate** button in the **Origin Certificates** section:

![img](https://i.imgur.com/75mpH5l.png)
![img](https://i.imgur.com/b8wFnMq.png)
![img](https://i.imgur.com/SGZ8ETO.png)

We’ll use the **/etc/ssl/certs** directory on the server to hold the origin certificate. The **/etc/ssl/private** directory will hold the private key file. Both folders already exist on the server.

First, copy the contents of the **Origin Certificate** displayed in the dialog box in your browser.

Create folder for Certificate and KEY

```shell
sudo mkdir /etc/ssl/certs/example.com
sudo mkdir /etc/ssl/private/example.com
```


Then, on your server, open **/etc/ssl/certs/cert.pem** for editing:

```shell
sudo nano /etc/ssl/certs/example.com/cert.pem
```
Paste the certificate contents into the file. Then save and exit the editor.

Then return to your browser and copy the contents of the **Private key**. Open the file **/etc/ssl/private/key.pem** for editing:

```shell
sudo nano /etc/ssl/private/example.com/key.pem
```
Paste the key into the file, save the file, and exit the editor.



## Step 2 – Installing Nginx
Because Nginx is available in Ubuntu’s default repositories, it is possible to install it from these repositories using the apt packaging system.

Since this is our first interaction with the apt packaging system in this session, we will update our local package index so that we have access to the most recent package listings. Afterwards, we can install nginx:

```shell
sudo apt update
sudo apt install nginx
```
After accepting the procedure, apt will install Nginx and any required dependencies to your server.

Before testing Nginx, the firewall software needs to be adjusted to allow access to the service. Nginx registers itself as a service with **ufw** upon installation, making it straightforward to allow Nginx access.

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

`Nginx Full`: This profile opens both port 80 (normal, unencrypted web traffic) and port 443 (TLS/SSL encrypted traffic).

`Nginx HTTP`: This profile opens only port 80 (normal, unencrypted web traffic).

`Nginx HTTPS`: This profile opens only port 443 (TLS/SSL encrypted traffic).


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


At the end of the installation process, Ubuntu 18.04 starts Nginx. The web server should already be up and running.

We can check with the systemd init system to make sure the service is running by typing:

```shell
sudo systemctl status nginx
```

Now that you have your web server up and running, let’s review some basic management commands.

To stop your web server, type:

```shell
sudo systemctl stop nginx
```

To start the web server when it is stopped, type:

```shell
sudo systemctl start nginx
```

To stop and then start the service again, type:

```shell
sudo systemctl restart nginx
```

If you are simply making configuration changes, Nginx can often reload without dropping connections. To do this, type:

```shell
sudo systemctl reload nginx
```

By default, Nginx is configured to start automatically when the server boots. If this is not what you want, you can disable this behavior by typing:

```shell
sudo systemctl disable nginx
```

To re-enable the service to start up at boot, you can type:

```shell
sudo systemctl enable nginx
```

Nginx on Ubuntu 18.04 has one server block enabled by default that is configured to serve documents out of a directory at **/var/www/html**. While this works well for a single site, it can become unwieldy if you are hosting multiple sites. Instead of modifying **/var/www/html**, let’s create a directory structure within **/var/www **for our example.com site, leaving **/var/www/html** in place as the default directory to be served if a client request doesn’t match any other sites.

Create the directory for **example.com** as follows, using the **-p** flag to create any necessary parent directories:

```shell
sudo mkdir -p /var/www/example.com/html
```
Next, assign ownership of the directory with the $USER environment variable:

```shell
sudo chown -R $USER:$USER /var/www/example.com/html
```

The permissions of your web roots should be correct if you haven’t modified your umask value, but you can make sure by typing:

```shell
sudo chmod -R 755 /var/www/example.com
```

Next, create a sample index.html page using nano or your favorite editor:

```shell
sudo nano /var/www/example.com/html/index.html
```

Inside, add the following sample HTML:

```html
<html>
    <head>
        <title>Welcome to Example.com!</title>
    </head>
    <body>
        <h1>Success!  The example.com server block is working!</h1>
    </body>
</html>
```
Save and close the file when you are finished.


To avoid a possible hash bucket memory problem that can arise from adding additional server names, it is necessary to adjust a single value in the <code>/etc/nginx/nginx.conf</code> file. Open the file:

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
sudo systemctl restart nginx
```

## Step 2 — Installing the Origin CA certificate in Nginx
In the previous section, you generated an origin certificate and private key using Cloudlfare’s dashboard and saved the files to your server. Now you’ll update the Nginx configuration for your site to use the origin certificate and private key to secure the connection between Cloudflare’s servers and your server.

Nginx creates a default server block during installation. Remove it if it exists, as you’ve already configured a custom server block for your domain:

```shell
sudo rm /etc/nginx/sites-enabled/default
```
Next, create the Nginx configuration file for your domain:

```shell
sudo nano /etc/nginx/sites-available/example.com
```

We’ll the Nginx configuration file to do the following:

- Listen on port 80 and redirect all requests to use https.

- Listen on port 443 and use the origin certificate and private key that you added in the previous section.


Paste following code to  the Nginx configuration file:

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
    ssl_certificate         /etc/ssl/certs/example.com/cert.pem;
    ssl_certificate_key     /etc/ssl/private/example.com/key.pem;

    server_name example.com www.example.com;

    root /var/www/example.com/html;
    index index.php index.html index.htm;

    charset utf-8;


    location / {
            try_files $uri $uri/ =404;
    }
}
```

Next, let’s enable the file by creating a link from it to the sites-enabled directory, which Nginx reads from during startup:

```shell
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/
```
Save the file and exit the editor.

Next, test to make sure that there are no syntax errors in any of your Nginx configuration files:

```shell
sudo nginx -t
```

If no problems were found, restart Nginx to enable your changes:

```shell
sudo systemctl restart nginx
```

Now go to the Cloudflare dashboard’s **SSL/TLS** section and change SSL mode to Full. This informs Cloudflare to always encrypt the connection between Cloudflare and your origin Nginx server.

![img](https://i.imgur.com/YqGbAUH.png)

Now visit your website at https://example.com to verify that it’s set up properly. You’ll see your home page displayed, and the browser will report that the site is secure.

## Step 4 — Setting Up Authenticated Origin Pulls

The Origin CA certificate will help Cloudflare verify that it is talking to the correct origin server. But how can your origin Nginx server verify that it is actually talking to Cloudflare? Enter TLS Client Authentication.

In a client authenticated TLS handshake, both sides provide a certificate to be verified. The origin server is configured to only accept requests that use a valid client certificate from Cloudflare. Requests which have not passed through Cloudflare will be dropped as they will not have Cloudflare’s certificate. This means that attackers cannot circumvent Cloudflare’s security measures and directly connect to your Nginx server.

Cloudflare presents certificates signed by a CA with the following certificate:

```text
-----BEGIN CERTIFICATE-----
MIIGBjCCA/CgAwIBAgIIV5G6lVbCLmEwCwYJKoZIhvcNAQENMIGQMQswCQYDVQQG
EwJVUzEZMBcGA1UEChMQQ2xvdWRGbGFyZSwgSW5jLjEUMBIGA1UECxMLT3JpZ2lu
IFB1bGwxFjAUBgNVBAcTDVNhbiBGcmFuY2lzY28xEzARBgNVBAgTCkNhbGlmb3Ju
aWExIzAhBgNVBAMTGm9yaWdpbi1wdWxsLmNsb3VkZmxhcmUubmV0MB4XDTE1MDEx
MzAyNDc1M1oXDTIwMDExMjAyNTI1M1owgZAxCzAJBgNVBAYTAlVTMRkwFwYDVQQK
ExBDbG91ZEZsYXJlLCBJbmMuMRQwEgYDVQQLEwtPcmlnaW4gUHVsbDEWMBQGA1UE
BxMNU2FuIEZyYW5jaXNjbzETMBEGA1UECBMKQ2FsaWZvcm5pYTEjMCEGA1UEAxMa
b3JpZ2luLXB1bGwuY2xvdWRmbGFyZS5uZXQwggIiMA0GCSqGSIb3DQEBAQUAA4IC
DwAwggIKAoICAQDdsts6I2H5dGyn4adACQRXlfo0KmwsN7B5rxD8C5qgy6spyONr
WV0ecvdeGQfWa8Gy/yuTuOnsXfy7oyZ1dm93c3Mea7YkM7KNMc5Y6m520E9tHooc
f1qxeDpGSsnWc7HWibFgD7qZQx+T+yfNqt63vPI0HYBOYao6hWd3JQhu5caAcIS2
ms5tzSSZVH83ZPe6Lkb5xRgLl3eXEFcfI2DjnlOtLFqpjHuEB3Tr6agfdWyaGEEi
lRY1IB3k6TfLTaSiX2/SyJ96bp92wvTSjR7USjDV9ypf7AD6u6vwJZ3bwNisNw5L
ptph0FBnc1R6nDoHmvQRoyytoe0rl/d801i9Nru/fXa+l5K2nf1koR3IX440Z2i9
+Z4iVA69NmCbT4MVjm7K3zlOtwfI7i1KYVv+ATo4ycgBuZfY9f/2lBhIv7BHuZal
b9D+/EK8aMUfjDF4icEGm+RQfExv2nOpkR4BfQppF/dLmkYfjgtO1403X0ihkT6T
PYQdmYS6Jf53/KpqC3aA+R7zg2birtvprinlR14MNvwOsDOzsK4p8WYsgZOR4Qr2
gAx+z2aVOs/87+TVOR0r14irQsxbg7uP2X4t+EXx13glHxwG+CnzUVycDLMVGvuG
aUgF9hukZxlOZnrl6VOf1fg0Caf3uvV8smOkVw6DMsGhBZSJVwao0UQNqQIDAQAB
o2YwZDAOBgNVHQ8BAf8EBAMCAAYwEgYDVR0TAQH/BAgwBgEB/wIBAjAdBgNVHQ4E
FgQUQ1lLK2mLgOERM2pXzVc42p59xeswHwYDVR0jBBgwFoAUQ1lLK2mLgOERM2pX
zVc42p59xeswCwYJKoZIhvcNAQENA4ICAQDKDQM1qPRVP/4Gltz0D6OU6xezFBKr
LWtDoA1qW2F7pkiYawCP9MrDPDJsHy7dx+xw3bBZxOsK5PA/T7p1dqpEl6i8F692
g//EuYOifLYw3ySPe3LRNhvPl/1f6Sn862VhPvLa8aQAAwR9e/CZvlY3fj+6G5ik
3it7fikmKUsVnugNOkjmwI3hZqXfJNc7AtHDFw0mEOV0dSeAPTo95N9cxBbm9PKv
qAEmTEXp2trQ/RjJ/AomJyfA1BQjsD0j++DI3a9/BbDwWmr1lJciKxiNKaa0BRLB
dKMrYQD+PkPNCgEuojT+paLKRrMyFUzHSG1doYm46NE9/WARTh3sFUp1B7HZSBqA
kHleoB/vQ/mDuW9C3/8Jk2uRUdZxR+LoNZItuOjU8oTy6zpN1+GgSj7bHjiy9rfA
F+ehdrz+IOh80WIiqs763PGoaYUyzxLvVowLWNoxVVoc9G+PqFKqD988XlipHVB6
Bz+1CD4D/bWrs3cC9+kk/jFmrrAymZlkFX8tDb5aXASSLJjUjcptci9SKqtI2h0J
wUGkD7+bQAr+7vr8/R+CBmNMe7csE8NeEX6lVMF7Dh0a1YKQa6hUN18bBuYgTMuT
QzMmZpRpIBB321ZBlcnlxiTJvWxvbCPHKHj20VwwAz7LONF59s84ZsOqfoBv8gKM
s0s5dsq5zpLeaw==
-----END CERTIFICATE-----
```

You can also download the certificate directly from Cloudflare here.
[https://support.cloudflare.com/hc/en-us/article_attachments/201243967/origin-pull-ca.pem](https://support.cloudflare.com/hc/en-us/article_attachments/201243967/origin-pull-ca.pem)

Copy this certificate. Then create the file **/etc/ssl/certs/example.com/cloudflare.crt** file to hold Cloudflare’s certificate:

```shell
sudo nano /etc/ssl/certs/example.com/cloudflare.crt
```
Paste the certificate into the file. Then save the file and exit the editor.

Now update your Nginx configuration to use TLS Authenticated Origin Pulls. Open the configuration file for your domain:

```shell
sudo nano /etc/nginx/sites-available/example.com
```

Add the **ssl_client_certificate** and **ssl_verify_client** directives as shown in the following example:

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
    ssl_certificate         /etc/ssl/certs/example.com/cert.pem;
    ssl_certificate_key     /etc/ssl/private/example.com/key.pem;
    ssl_client_certificate  /etc/ssl/certs/example.com/cloudflare.crt;
    ssl_verify_client on;

    server_name example.com www.example.com;

    root /var/www/example.com/html;
    index index.php index.html index.htm;

    charset utf-8;


    location / {
            try_files $uri $uri/ =404;
    }
}
```

Save the file and exit the editor.

Next, test to make sure that there are no syntax errors in your Nginx configuration.

```shell
sudo nginx -t
```
If no problems were found, restart Nginx to enable your changes:

```shell
sudo systemctl restart nginx
```

Finally, to enable Authenticated Pulls, open the **SSL/TLS** section in the Cloudflare dashboard and toggle the **Authenticated Origin Pulls** option.

![img](https://i.imgur.com/IjIRTex.png)

Now visit your website at **https://example.com** to verify that it was set up properly. As before, you’ll see your home page displayed.

To verify that your server will only accept requests signed by Cloudflare’s CA, toggle the **Authenticated Origin Pulls** option to disable it and then reload your website. You should get the following error message :

![img](https://i.imgur.com/ENwiG8V.png)

## Logs

```bash
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log
```
