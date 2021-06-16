#!/usr/bin/env bash

# Configura o GIT depois da loja instalada
cd /var/www/html/$STORENAME
git init
git remote add origin $GITURL
git remote set-url origin $GITURL
git fetch --all
git checkout $GITBRANCH -f
git pull -f