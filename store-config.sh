#!/usr/bin/env bash

# Set information configs store
cd /var/www/html/$STORENAME
echo "Running admin configs..."

systemctl restart elasticsearch

php bin/magento setup:install \
        --base-url=https://$STOREURL/ \
        --db-host=$DBHOST \
        --db-name=$STORENAME \
        --db-user=$STORENAME \
        --db-password=$DBPSWD \
        --admin-firstname=admin \
        --admin-lastname=admin \
        --admin-email=admin@admin.com \
        --admin-user=admin \
        --admin-password=$ADMINPSWD \
        --backend-frontname=admin \
        --use-rewrites=1 \
        --elasticsearch-host=localhost \
        --elasticsearch-port=9200 \
        --session-save-redis-port=6379 \
        --session-save-redis-host=localhost \
        --session-save-redis-db=1 \
        --cache-backend-redis-port=6379 \
        --cache-backend-redis-server=localhost \
        --cache-backend-redis-db=0 \
        --page-cache-redis-port=6379 \
        --page-cache-redis-server=localhost \
        --page-cache-redis-db=2 \
        --cleanup-database

echo "Running bistwobis configs..."
php bin/magento config:set admin/dashboard/enable_charts 1 &&
php bin/magento config:set admin/security/lockout_failures '0' &&
php bin/magento config:set admin/security/lockout_threshold '' &&
php bin/magento config:set admin/security/password_is_forced 0 &&
php bin/magento config:set admin/security/password_lifetime '' &&
php bin/magento config:set admin/security/session_lifetime 31536000 &&
php bin/magento config:set admin/security/use_form_key 0 &&
php bin/magento config:set cataloginventory/options/show_out_of_stock 1
php bin/magento config:set customer/password/required_character_classes_number 2 &&
php bin/magento config:set dev/image/default_adapter IMAGEMAGICK &&
php bin/magento config:set general/country/allow BR &&
php bin/magento config:set general/country/default BR &&
php bin/magento config:set general/country/destinations BR &&
php bin/magento config:set general/country/optional_zip_countries BR &&
php bin/magento config:set general/locale/code pt_BR &&
php bin/magento config:set general/locale/timezone America/Sao_Paulo &&
php bin/magento config:set general/locale/weight_unit kgs &&
php bin/magento config:set general/region/display_all 1 &&
php bin/magento config:set general/region/state_required BR &&
php bin/magento config:set general/single_store_mode/enabled 1 &&
php bin/magento config:set general/store_information/country_id BR &&
php bin/magento config:set general/store_information/region_id 499 &&
php bin/magento config:set general/store_information/name 'Bis2bis E-commerce' &&
php bin/magento config:set general/store_information/phone '43 3326-1500' &&
php bin/magento config:set general/store_information/postcode '86050-435' &&
php bin/magento config:set general/store_information/city 'Londrina' &&
php bin/magento config:set general/store_information/street_line1 'Bento Munhoz da Rocha Neto' &&
php bin/magento config:set general/store_information/merchant_vat_number '10.738.352/0001-00' &&
php bin/magento config:set oauth/access_token_lifetime/customer '' &&
php bin/magento config:set oauth/access_token_lifetime/admin '' &&
php bin/magento config:set oauth/consumer/expiration_period 31536000 &&
php bin/magento config:set sales_email/general/async_sending 1 &&
php bin/magento config:set shipping/origin/country_id BR &&
php bin/magento config:set shipping/origin/region_id 499 &&
php bin/magento config:set shipping/origin/postcode 86050-435 &&
php bin/magento config:set shipping/origin/city Londrina &&
php bin/magento config:set shipping/origin/street_line1 'Rua Bento Munhoz da Rocha Neto' &&
php bin/magento config:set system/backup/functionality_enabled 1 &&
php bin/magento config:set system/currency/installed BRL &&
php bin/magento config:set system/upload_configuration/jpeg_quality 90 &&
php bin/magento config:set system/upload_configuration/max_height 1080 &&
php bin/magento config:set web/seo/use_rewrites 1 &&
php bin/magento config:set web/secure/use_in_frontend 1 &&
php bin/magento config:set web/secure/use_in_adminhtml 1 &&
php bin/magento config:set catalog/search/elasticsearch7_index_prefix "$STORENAME"

php bin/magento config:set dev/static/sign 0
php bin/magento cache:flush
php bin/magento cache:clean
php bin/magento mo:di Magento_TwoFactorAuth
chown -R www-data:www-data /var/www/html/$STORENAME
php bin/magento setup:store-config:set --base-url="http://$STOREURL/"
php bin/magento setup:store-config:set --base-url-secure="https://$STOREURL/"
php bin/magento setup:upgrade
php bin/magento setup:di:compile
php bin/magento setup:static-content:deploy -f

if [[ $GITBRANCH = 'main' ]] || [[ $GITBRANCH = 'master' ]]
	then
		php bin/magento deploy:mode:set production
	else
		php bin/magento deploy:mode:set developer
fi
