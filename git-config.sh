#!/usr/bin/env bash

# Configura o GIT depois da loja instalada
cd /var/www/html/$STORENAME
chown -R www-data:www-data ../$STORENAME
sudo -H -u www-data bash -c "git init"
sudo -H -u www-data bash -c "git remote add origin $GITREPO"
sudo -H -u www-data bash -c "git remote set-url origin $GITREPO"
sudo -H -u www-data bash -c "git fetch --all "
sudo -H -u www-data bash -c "git checkout $GITBRANCH -f"
sudo -H -u www-data bash -c "git pull -f"