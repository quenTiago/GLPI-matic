# Serveur GLPI via Vagrant

Ce projet permet de déployer rapidement une instance locale de **GLPI** (Gestionnaire Libre de Parc Informatique) pour le test ou le développement.

## Prérequis

- [Vagrant](https://www.vagrantup.com/downloads) installé.
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (ou un autre provider compatible) installé.

## Installation et Démarrage

1. Ouvrez un terminal dans le dossier contenant le `Vagrantfile`.
2. Lancez la commande suivante pour télécharger l'image Ubuntu et provisionner le serveur :
   ```bash
   vagrant up