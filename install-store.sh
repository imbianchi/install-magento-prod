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

bash ./nginx-config.sh
bash ./create-project.sh
bash ./git-config.sh
bash ./store-config.sh

ADMINURL=$(cat /var/www/html/$STORENAME/app/etc/env.php | grep admin | awk '{print $3}' | sed "s/'//g" | awk '{print "https://'$STORENAME'.bisws.com.br/"$0}')
echo $ADMINURL
