
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
