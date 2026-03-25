Excellente idée ! Mettre tout ça sur GitHub est la meilleure façon de garder ton code au chaud et de le partager.

Voici l'intégralité de ton projet formaté en Markdown. Tu n'as plus qu'à copier-coller chaque bloc de code dans les fichiers correspondants de ton dépôt.

1. Le fichier Vagrantfile
Crée un fichier nommé exactement Vagrantfile (sans extension) à la racine de ton projet :

Ruby
Vagrant.configure("2") do |config|
  # Utilisation d'Ubuntu 22.04 LTS (Jammy Jellyfish)
  config.vm.box = "ubuntu/jammy64"
  
  # Redirection de port : on accèdera à GLPI via http://localhost:8080
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # Configuration des ressources de la VM (VirtualBox)
  config.vm.provider "virtualbox" do |vb|
    vb.name = "glpi_server"
    vb.memory = "2048"
    vb.cpus = 2
  end

  # Lancement du script d'installation automatique
  config.vm.provision "shell", path: "provision.sh"
end
2. Le fichier provision.sh
Crée un fichier nommé provision.sh à la racine de ton projet :

Bash
#!/bin/bash

echo "=== Mise à jour du système ==="
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get upgrade -y

echo "=== Installation de la pile LAMP et des extensions PHP ==="
apt-get install -y apache2 mariadb-server php php-mysql php-xml php-curl php-gd \
                   php-mbstring php-intl php-bz2 php-ldap php-apcu wget tar

echo "=== Configuration de la base de données MariaDB ==="
mysql -e "CREATE DATABASE glpidb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -e "CREATE USER 'glpiuser'@'localhost' IDENTIFIED BY 'glpipwd';"
mysql -e "GRANT ALL PRIVILEGES ON glpidb.* TO 'glpiuser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

echo "=== Téléchargement et extraction de GLPI ==="
cd /tmp
wget -q https://github.com/glpi-project/glpi/releases/download/10.0.15/glpi-10.0.15.tgz
tar -xzf glpi-10.0.15.tgz -C /var/www/html/

echo "=== Configuration des permissions ==="
chown -R www-data:www-data /var/www/html/glpi
chmod -R 755 /var/www/html/glpi

echo "=== Configuration d'Apache (VirtualHost) ==="
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

echo "=== Installation terminée ! Rendez-vous sur http://localhost:8080 ==="
3. Le fichier README.md
Crée (ou remplace) le fichier README.md à la racine de ton projet. Ce format s'affichera parfaitement sur la page d'accueil de ton dépôt GitHub :

Markdown
# Serveur GLPI via Vagrant

Ce projet permet de déployer rapidement une instance locale de **GLPI** (Gestionnaire Libre de Parc Informatique) avec une pile LAMP complète (Ubuntu 22.04, Apache, MariaDB, PHP) pour faire des tests ou du développement.

## 📦 Prérequis

- [Vagrant](https://www.vagrantup.com/downloads) installé sur votre machine.
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (ou un autre hyperviseur compatible) installé.

## 🚀 Installation et Démarrage

1. Clonez ce dépôt et ouvrez un terminal dans le dossier.
2. Lancez la création et la configuration automatique de la machine avec la commande :
   \`\`\`bash
   vagrant up
   \`\`\`
   *(Le premier lancement prendra quelques minutes, le temps de télécharger l'image Ubuntu et d'installer les paquets).*

## ⚙️ Configuration Web de GLPI

Une fois la commande \`vagrant up\` terminée, ouvrez votre navigateur et allez sur :

👉 **URL :** [http://localhost:8080](http://localhost:8080)

L'assistant d'installation web de GLPI va s'afficher. Suivez ces étapes :
1. Choisissez la langue, acceptez la licence et cliquez sur **Installer**.
2. Les vérifications de l'environnement doivent toutes être validées (en vert).
3. **Configuration de la base de données :** Renseignez exactement ces informations :
   - **Serveur SQL :** \`localhost\`
   - **Utilisateur SQL :** \`glpiuser\`
   - **Mot de passe SQL :** \`glpipwd\`
4. Cliquez sur Continuer.
5. **Sélectionnez la base de données :** Choisissez \`glpidb\` dans la liste et terminez l'installation.

## 🔑 Première Connexion

⚠️ **Ne vous connectez pas avec l'utilisateur de la base de données !** Utilisez les comptes créés par défaut par GLPI :

- **Super-Administrateur :** \`glpi\` / \`glpi\`
- **Administrateur :** \`tech\` / \`tech\`
- **Compte normal :** \`normal\` / \`normal\`
- **Post-only :** \`post-only\` / \`post-only\`

## 🔒 Actions Post-Installation (Sécurité)

Dès votre première connexion, résolvez les alertes de sécurité de GLPI :

1. **Supprimer le fichier d'installation :**
   Ouvrez votre terminal sur votre machine hôte et lancez cette commande :
   \`\`\`bash
   vagrant ssh -c "sudo rm /var/www/html/glpi/install/install.php"
   \`\`\`

2. **Changer les mots de passe par défaut :**
   Dans l'interface GLPI, allez dans les paramètres des utilisateurs et modifiez les mots de passe des comptes par défaut.

## 🛠️ Commandes Vagrant utiles

- **Arrêter la VM proprement :** \`vagrant halt\`
- **Relancer la VM :** \`vagrant up\`
- **Se connecter en SSH à la VM :** \`vagrant ssh\`
- **Détruire la VM (⚠️ Supprime toutes les données) :** \`vagrant destroy\`
