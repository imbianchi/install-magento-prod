# install-magento-prod

Script de instalação de loja magento 2 em servidores de desenvolvimento - `.bisws.com.br`.
Para instalar a loja com sucesso, o user deve estar com privilégios root (sudo su);

Rode os seguintes comandos:

1 - git clone git@github.com:bianchijoao/install-magento-prod.git /var/www/html/
2 - cd /var/www/html/install-magento-prod/
3 - bash install-store.sh
4 - Inserir dados solicitados
5 - systemctl restart nginx

Pronto. Sua loja estará no domínio registrado.
