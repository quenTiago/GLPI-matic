# Serveur GLPI via Vagrant

Ce projet permet de déployer rapidement une instance locale de **GLPI** (Gestionnaire Libre de Parc Informatique) ainsi que **phpMyAdmin** pour l'administration de la base de données, à des fins de test ou de développement.

## Prérequis

- [Vagrant](https://www.vagrantup.com/downloads) installé.
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (ou un autre provider compatible) installé.

## Installation et Démarrage

1. Ouvrez un terminal dans le dossier contenant le `Vagrantfile`.
2. Lancez la commande suivante pour télécharger l'image Ubuntu et provisionner le serveur :
   ```bash
   vagrant up
   ```
3. Une fois le provisionnement terminé, les services sont accessibles aux adresses suivantes :

| Service      | URL                        | Identifiants                      |
|--------------|----------------------------|-----------------------------------|
| GLPI         | http://localhost:8080      | (configuration initiale via l'UI) |
| phpMyAdmin   | http://localhost:8081      | `glpiuser` / `glpipwd`            |

## Ce qui est installé automatiquement

Le script `provision.sh` installe et configure les éléments suivants sur une VM Ubuntu 22.04 LTS :

- **Apache2** — Serveur web avec deux VirtualHosts (port 80 pour GLPI, port 8081 pour phpMyAdmin)
- **MariaDB** — Base de données avec une DB `glpidb` et un utilisateur `glpiuser` dédiés
- **PHP** et ses extensions nécessaires à GLPI
- **GLPI 10.0.15** — Déployé dans `/var/www/html/glpi`
- **phpMyAdmin** — Interface d'administration de la base de données

## Structure du projet

```
.
├── Vagrantfile       # Configuration de la VM (ressources, ports, provider)
├── provision.sh      # Script d'installation automatique
└── README.md         # Ce fichier
```

## Configuration de la VM

| Paramètre | Valeur        |
|-----------|---------------|
| Box       | ubuntu/jammy64 (22.04 LTS) |
| RAM       | 2048 Mo       |
| CPU       | 2 cœurs       |
| Port GLPI | 8080 (hôte) → 80 (VM) |
| Port phpMyAdmin | 8081 (hôte) → 8081 (VM) |

## Commandes utiles

```bash
# Démarrer la VM
vagrant up

# Arrêter la VM
vagrant halt

# Relancer le provisionnement
vagrant provision

# Se connecter en SSH à la VM
vagrant ssh

# Supprimer la VM
vagrant destroy
```

## Informations de connexion à la base de données

| Paramètre | Valeur     |
|-----------|------------|
| Hôte      | localhost  |
| Base      | glpidb     |
| Utilisateur | glpiuser |
| Mot de passe | glpipwd |
