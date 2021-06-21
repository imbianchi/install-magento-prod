#!/usr/bin/env bash

request_uri='$request_uri'
host='$host'
http_x_forwarded_proto='$http_x_forwarded_proto'
MAGE_ROOT='$MAGE_ROOT'
port="listen 80;"
serverDevName="server_name $STORENAME.bisws.com.br;"
serverProdName="server_name $STORENAME.com.br  www.$STORENAME.com.br;"
setServerDir="set $MAGE_ROOT /var/www/html/$STORENAME;"
accessLog="access_log /var/log/nginx/$STORENAME-access.log;"
errorLog="error_log /var/log/nginx/$STORENAME-error.log;"
includeSample="include /etc/nginx/conf.d/nginx.conf.sample;"
redirectsTo="
        #redirect to HTTPS behind ELB
        if ($http_x_forwarded_proto != 'https') {
            return 301 https://$host$request_uri;
          }
"
serverConfig="
        client_max_body_size 100M;
        proxy_connect_timeout 600; 
        proxy_send_timeout 600; 
        proxy_read_timeout 600; 
        send_timeout 600;
        client_header_timeout 600;
        client_body_timeout 600;
        fastcgi_read_timeout 600;
"

developConfig="server {
        $serverConfig

        $port
        
        $serverDevName
        $setServerDir
        
        $redirectsTo

        $accessLog
        $errorLog

       $includeSample
}"

productionConfig="server {
        $serverConfig

        $port
        
        $serverProdName
        $setServerDir
        
        $redirectsTo

        $accessLog
        $eerorLog

       $includeSample
}"

# create the respective file in the respective directory
if [[ $GITBRANCH = 'main' ]] || [[ $GITBRANCH = 'master' ]]
    then
        cd /etc/nginx/sites-enabled/
        touch ./$STORENAME.conf &&
        echo $productionConfig >> ./$STORENAME.conf
    else
        cd /etc/nginx/conf.d/
        touch ./$STORENAME &&
        echo $developConfig >> ./$STORENAME
fi
