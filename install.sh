#!/usr/bin/env bash

# Getting minimun information to install
echo -n "Store name: "
read STORENAME

echo -n "Store domain: "
read STOREURL

echo -n "Store git repository: "
read GITREPO

echo -n "Git branch: "
read GITBRANCH

echo -n "DB password: "
read DBPSWD

echo -n "Admin password: "
read ADMINPSWD

echo -n "DB host: "
read DBHOST

export STORENAME
export STOREURL
export GITREPO
export GITBRANCH
export DBPSWD
export ADMINPSWD
export DBHOST

systemctl restart elasticsearch

bash ./nginx-config.sh
bash ./create-project.sh
bash ./git-config.sh

sudo -H -u www-data bash -c "rm -r /var/www/html/$STORENAME/vendor"
cd /var/www/html/$STORENAME
sudo -H -u www-data bash -c "composer install"

bash /var/www/html/install-magento-prod/store-config.sh

systemctl restart nginx

ADMINURL=$(cat /var/www/html/$STORENAME/app/etc/env.php | grep admin | awk '{print $3}' | sed "s/'//g" | awk '{print "https://'$STORENAME'.bisws.com.br/"$0}')
echo $ADMINURL
