#!/bin/bash

echo "=== Mise à jour du système ==="
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get upgrade -y

echo "=== Installation de la pile LAMP et des extensions PHP ==="
apt-get install -y apache2 mariadb-server php php-mysql php-xml php-curl php-gd \
                   php-mbstring php-intl php-bz2 php-ldap php-apcu wget tar

echo "=== Configuration de la base de données MariaDB ==="
# Création de la DB et de l'utilisateur pour GLPI
mysql -e "CREATE DATABASE glpidb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -e "CREATE USER 'glpiuser'@'localhost' IDENTIFIED BY 'glpipwd';"
mysql -e "GRANT ALL PRIVILEGES ON glpidb.* TO 'glpiuser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

echo "=== Téléchargement et extraction de GLPI ==="
cd /tmp
# Tu peux changer le lien ici s'il y a une version plus récente
wget -q https://github.com/glpi-project/glpi/releases/download/10.0.15/glpi-10.0.15.tgz
tar -xzf glpi-10.0.15.tgz -C /var/www/html/

echo "=== Configuration des permissions ==="
chown -R www-data:www-data /var/www/html/glpi
chmod -R 755 /var/www/html/glpi

echo "=== Configuration d'Apache (VirtualHost GLPI) ==="
# Création du VHost en pointant sur le dossier /public comme recommandé pour GLPI 10+
cat <<EOF > /etc/apache2/sites-available/glpi.conf
<VirtualHost *:80>
    DocumentRoot /var/www/html/glpi/public

    <Directory /var/www/html/glpi/public>
        Require all granted
        RewriteEngine On
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteRule ^(.*)$ index.php [QSA,L]
    </Directory>
    
    ErrorLog \${APACHE_LOG_DIR}/glpi_error.log
    CustomLog \${APACHE_LOG_DIR}/glpi_access.log combined
</VirtualHost>
EOF

# Activation des modules, du site et redémarrage d'Apache
a2enmod rewrite
a2dissite 000-default.conf
a2ensite glpi.conf
systemctl restart apache2

echo "=== Installation de phpMyAdmin ==="
apt-get install -y phpmyadmin

# Création d'un VirtualHost Apache dédié sur le port 8081
cat <<EOF > /etc/apache2/sites-available/phpmyadmin.conf
Listen 8081

<VirtualHost *:8081>
    DocumentRoot /usr/share/phpmyadmin

    <Directory /usr/share/phpmyadmin>
        Options SymLinksIfOwnerMatch
        DirectoryIndex index.php
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/phpmyadmin_error.log
    CustomLog \${APACHE_LOG_DIR}/phpmyadmin_access.log combined
</VirtualHost>
EOF

a2ensite phpmyadmin.conf
systemctl restart apache2

echo "=== Installation terminée ! ==="
echo "  → GLPI        : http://localhost:8080"
echo "  → phpMyAdmin  : http://localhost:8081  (user: glpiuser / pwd: glpipwd)"
