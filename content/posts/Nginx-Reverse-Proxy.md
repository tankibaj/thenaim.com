+++
title = 'Nginx Reverse Proxy'
image = '/images/post/nginx.png'
author = 'Naim'
date = 2018-08-03
description = 'Nginx Reverse Proxy'
categories = ["nginx"]
type = 'post'
+++

Reverse proxying web applications and services improves system security, performance and operations. This article reviews four ways to route requests from a proxy web server to an origin web server.

Table of Contents
=================

* [Subdomain Reverse proxy](#subdomain-reverse-proxy)
* [Port Reverse proxy](#port-reverse-proxy)
* [Symmetric Path Reverse proxy](#symmetric-path-reverse-proxy)

## Subdomain Reverse proxy
**Context:** You own a subdomain and can map it one-to-one to an application.

**Example:** <code>https://app-name.example.com/xxxx</code> map to <code>http://127.0.0.1:3000/xxxx</code>

Create the nginx configuration:

```shell
sudo nano /etc/nginx/sites-available/app-name.example.com
```

Paste following code:

```nginx
upstream app_name {
  server 127.0.0.1:3000;
}

server {
    listen 80;
    listen [::]:80;
    server_name app-name.example.com;
    return 302 https://$server_name$request_uri;
}

server {

    # SSL configuration

    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    ssl        on;
    ssl_certificate         /etc/ssl/certs/cert.pem;
    ssl_certificate_key     /etc/ssl/private/key.pem;
    #ssl_client_certificate /etc/ssl/certs/cloudflare.crt;
    #ssl_verify_client on;

    server_name app-name.example.com;

    location / {
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Host $http_host;
      proxy_set_header X-NginX-Proxy true;

      proxy_pass http://app_name;
      proxy_redirect off;
    }
}
```

## Port Reverse proxy
**Context:** The application serves content on the root path or its content is difficult to transform, however you can open up a dedicated port.

**Example:** <code>https://app-name2.example.com:8443/xxxx</code> map to <code>http://127.0.0.1:8080/xxxx</code>

Create the nginx configuration:

```shell
sudo nano /etc/nginx/sites-available/app-name2.example.com
```

Paste following code:

```nginx
upstream app_name {
  server 127.0.0.1:8080;
}

#server {
#    listen 80;
#    listen [::]:80;
#    server_name app-name2.example.com;
#    return 302 https://$server_name$request_uri;
#}

server {

    # SSL configuration

    listen 8443 ssl;
    #listen 8443 ssl http2;
    #listen [::]:8443 ssl http2;
    ssl        on;
    ssl_certificate         /etc/ssl/certs/cert.pem;
    ssl_certificate_key     /etc/ssl/private/key.pem;
    #ssl_client_certificate /etc/ssl/certs/cloudflare.crt;
    #ssl_verify_client on;

    server_name app-name2.example.com;


    location / {
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Host $http_host;
      proxy_set_header X-NginX-Proxy true;

      proxy_pass http://app_name;
      proxy_redirect off;
    }
}
```

## Symmetric Path Reverse proxy
**Context:** The application serves content on a unique path.

**Example:** <code>https://app-name.example.com/app_path/xxxx</code> map to <code>http://127.0.0.1:3000/app_path/xxxx</code>

Create the nginx configuration:

```shell
sudo nano /etc/nginx/sites-available/app-name.example.com
```

Paste following code:

```nginx
upstream app_name {
  server 127.0.0.1:3000;
}

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
    ssl        on;
    ssl_certificate         /etc/ssl/certs/cert.pem;
    ssl_certificate_key     /etc/ssl/private/key.pem;

    server_name example.com www.example.com;

    root /var/www/example.com/html;
    index index.html index.htm index.nginx-debian.html;


    location / {
            try_files $uri $uri/ =404;
    }


    location /app_path {
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Host $http_host;
      proxy_set_header X-NginX-Proxy true;

      proxy_pass http://app_name/app_path;
      proxy_redirect off;
    }
}
```

Next, let’s enable the file by creating a link from it to the sites-enabled directory, which Nginx reads from during startup:

```shell
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/
```

Next, test to make sure that there are no syntax errors in any of your Nginx configuration files:

```shell
sudo nginx -t
```

If no problems were found, restart Nginx to enable your changes:

```shell
sudo systemctl restart nginx
```
