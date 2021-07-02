#!/usr/bin/env bash

request_uri='$request_uri'
host='$host'
http_x_forwarded_proto='$http_x_forwarded_proto'
MAGE_ROOT='$MAGE_ROOT'

if [ "$GITBRANCH" == "main" ] || [ "$GITBRANCH" == "master" ]
    then
        cd /etc/nginx/sites-enabled/
        touch ./$STORENAME &&
        echo "server {
        client_max_body_size 100M;
        proxy_connect_timeout 600; 
        proxy_send_timeout 600; 
        proxy_read_timeout 600; 
        send_timeout 600;
        client_header_timeout 600;
        client_body_timeout 600;
        fastcgi_read_timeout 600;

        listen 80;
        
        server_name $STORENAME.com.br  www.$STORENAME.com.br;
        set $MAGE_ROOT /var/www/html/$STORENAME;
        
        #redirect to HTTPS behind ELB
          if ($http_x_forwarded_proto != 'https') {
             return 301 https://$host$request_uri;
         }

        access_log /var/log/nginx/$STORENAME-access.log;
        error_log /var/log/nginx/$STORENAME-error.log;

       include /etc/nginx/conf.d/nginx.conf.sample;
}" >> ./$STORENAME
    else
        cd /etc/nginx/conf.d/
        touch ./$STORENAME.conf &&
        echo "server {
        client_max_body_size 100M;
        proxy_connect_timeout 600; 
        proxy_send_timeout 600; 
        proxy_read_timeout 600; 
        send_timeout 600;
        client_header_timeout 600;
        client_body_timeout 600;
        fastcgi_read_timeout 600;

        listen 80;
        
        server_name $STORENAME.bisws.com.br;
        set $MAGE_ROOT /var/www/html/$STORENAME;
        
        #redirect to HTTPS behind ELB
          if ($http_x_forwarded_proto != 'https') {
            return 301 https://$host$request_uri;
        }

        access_log /var/log/nginx/$STORENAME-access.log;
        error_log /var/log/nginx/$STORENAME-error.log;

       include /etc/nginx/conf.d/nginx.conf.sample;
}" >> ./$STORENAME.conf
        
fi