+++
title = 'Fetch Visitor IP From Cloudflare Proxy'
image = '/images/post/nginx.png'
author = 'Naim'
date = 2019-01-25
description = 'How to Fetch Visitor IP From Cloudflare Proxy'
categories = ["nginx", "cloudflare"]
type = 'post'
+++



CloudFlare is a great service that proxies your site’s traffic in order to offer performance gains and filtering options. It can compress and cache static content such as CSS files, JavaScript, and image files and then geographically optimize how they’re given to your users (think CDN).


One annoying issue, however, is the fact that because it’s a proxy you see incoming requests as coming from CloudFlare servers rather than the original client. So if you’re doing any cool data analytics on your server your source IP information will be borked.

There’s an easy way to fix it, however.



I run Nginx as my main webserver, and Ubuntu’s version of the app includes support for the `http-real-ip` module, which allows you to specify a set of proxy server IPs and the original IP header within the forwarded traffic so you can map it properly.



## Nginx Configuration



So, using Nginx, edit your `nginx.conf` file and add the following configuration to the server block:



```nginx
set_real_ip_from 103.21.244.0/22;
set_real_ip_from 103.22.200.0/22;
set_real_ip_from 103.31.4.0/22;
set_real_ip_from 104.16.0.0/12;
set_real_ip_from 108.162.192.0/18;
set_real_ip_from 131.0.72.0/22;
set_real_ip_from 141.101.64.0/18;
set_real_ip_from 162.158.0.0/15;
set_real_ip_from 172.64.0.0/13;
set_real_ip_from 173.245.48.0/20;
set_real_ip_from 188.114.96.0/20;
set_real_ip_from 190.93.240.0/20;
set_real_ip_from 197.234.240.0/22;
set_real_ip_from 198.41.128.0/17;
set_real_ip_from 2400:cb00::/32;
set_real_ip_from 2606:4700::/32;
set_real_ip_from 2803:f800::/32;
set_real_ip_from 2405:b500::/32;
set_real_ip_from 2405:8100::/32;
set_real_ip_from 2c0f:f248::/32;
set_real_ip_from 2a06:98c0::/29;

# use any of the following two
real_ip_header CF-Connecting-IP;
#real_ip_header X-Forwarded-For;
```



## CloudFlare IP List

The list of IP-addresses might be incomplete. Here you can find the up-to-date list of CloudFlare IP addresses:

https://www.cloudflare.com/ips
https://www.cloudflare.com/ips-v4

https://support.cloudflare.com/hc/en-us/articles/200170786-Restoring-original-visitor-IPs-Logging-visitor-IP-addresses-with-mod-cloudflare-



## Install Nginx Plugins

It's optional. If `real_ip_header` doesn't work on your server try to install nginx extra plugins.

```bash
sudo apt install nginx-extras
```

