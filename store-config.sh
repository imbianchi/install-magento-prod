#!/usr/bin/env bash

# Set information configs store
cd /var/www/html/$STORENAME
echo "Running admin configs..."
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
          --page-cache-redis-db=2

echo "Done."
echo "Running bistwobis configs..."
echo "running config bistwobis script..."
php bin/magento config:set \
          --admin/dashboard/enable_charts 1 \
          --admin/security/admin_account_sharing 1 \
          --admin/security/lockout_failures '0' \
          --admin/security/lockout_threshold '' \
          --admin/security/password_is_forced 0 \
          --admin/security/password_lifetime '' \
          --admin/security/session_lifetime 31536000 \
          --admin/security/use_form_key 0 \
          --cataloginventory/options/show_out_of_stock 1
          --customer/password/lockout_threshold 0 \
          --customer/password/required_character_classes_number 2 \
          --dev/image/default_adapter IMAGEMAGICK \
          --general/country/allow BR \
          --general/country/default BR \
          --general/country/destinations BR \
          --general/country/optional_zip_countries BR \
          --general/locale/code pt_BR \
          --general/locale/timezone America/Sao_Paulo \
          --general/locale/weight_unit kgs \
          --general/region/display_all 1 \
          --general/region/state_required BR \
          --general/single_store_mode/enabled 1 \
          --general/store_information/country_id BR \
          --general/store_information/region_id 499 \
          --general/store_information/name 'Bis2bis E-commerce' \
          --general/store_information/phone '43 3326-1500' \
          --general/store_information/postcode '86050-435' \
          --general/store_information/city 'Londrina' \
          --general/store_information/street_line1 'Bento Munhoz da Rocha Neto' \
          --general/store_information/merchant_vat_number '10.738.352/0001-00' \
          --oauth/access_token_lifetime/customer '' \
          --oauth/access_token_lifetime/admin '' \
          --oauth/consumer/expiration_period 31536000 \
          --sales_email/general/async_sending 1 \
          --sitemap/generate/enabled 1 \
          --sitemap/generate/time '02,00,00' \
          --sitemap/generate/frequency D \
          --shipping/origin/country_id BR \
          --shipping/origin/region_id 499 \
          --shipping/origin/postcode 86050-435 \
          --shipping/origin/city Londrina \
          --shipping/origin/street_line1 'Rua Bento Munhoz da Rocha Neto' \
          --system/backup/functionality_enabled 1 \
          --system/currency/installed BRL \
          --system/upload_configuration/jpeg_quality 90 \
          --system/upload_configuration/max_height 1080 \
          --web/seo/use_rewrites 1 \
          --web/secure/use_in_frontend 1 \
          --web/secure/use_in_adminhtml 1
          --cleanup-database

php bin/magento config:set dev/static/sign 0
php bin/magento setup:static-content:deploy -f
php bin/magento cache:flush
php bin/magento cache:clean
php bin/magento mo:di Magento_TwoFactorAuth
chown -R www-data:www-data /var/www/html/$STORENAME
php bin/magento setup:store-config:set --base-url="http://$STORENAME/"
php bin/magento setup:store-config:set --base-url-secure="https://$STORENAME/"
php bin/magento setup:upgrade
php bin/magento setup:di:compile