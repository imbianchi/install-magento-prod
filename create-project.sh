#!/usr/bin/env bash

/usr/bin/composer global config http-basic.repo.magento.com b97c2b50831ba3999e595c55b4db4dfc d2b34e2f95c0f29e89457343ca29ecea  
/usr/bin/composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition /var/www/html/$STORENAME
cd /var/www/html/$STORENAME
find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
chown -R www-data:www-data /var/www/html/$STORENAME # Ubuntu
chmod u+x bin/magento