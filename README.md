# MP2Arch
Ce projet a pour but de fournir une ISO Arch customisée permettant à des MP2I d'installer Arch Linux sans difficulté (et sans utiliser arch-install). 
Un guide d'installation d'Arch Linux écrit en français est disponible [ici](https://github.com/rafalou38/Guide-arch-Linux-du-Taupin). Pour tout ce qui n'est pas couvert par ce guide, se référer au [Arch Wiki](https://wiki.archlinux.org/title/Main_page).

La commande d'installation automatique procurée par cette ISO est `mp2i-install`, elle vous permettra de choisir des paramètres clés et fera le reste de l'installation pour vous.

## Structure
- Les fichiers utilisés pour la configuration automatique sont dans `airootfs/root`
- Les scripts pour l'installation automatique sont eux dans `airootfr/usr/local/bin`

## Installation automatique
En utilisant `mp2i-install`, un Arch linux barebones est installé, avec seulement de quoi se connecter à internet et les essentiels. Il est nécessaire d'être connecté à internet pour effectuer cette commande. Voici une liste de ce qui est fait par cette commande :
- Reset du disque et création de nouvelles partitions (en `ext4`)
- Choix d'un username, hostname et des mots de passe utilisateur / root
- Installation des packages essentiels via `pacstrap`
- Génération du `fstab`
- Setup de `GRUB` permettant de relancer la machine après l'installation
- Setup de `iwd` et `systemd` pour pouvoir se connecter à internet après l'installations
- Génération des fichiers de language... mise à l'heure...

### Liste des packages installés
- `base` et `base-devel`
- `linux` et `linux-firmware`
- `vim` (éditeur de texte basique)
- `grub` et `efibootmgr` (bootloader)
- `iwd` (internet)
- `sudo` (utilisation des permissions admin via l'utilisateur normal et son mot de passe)
- `zsh` (shell, alternative à bash couramment utilisée)
- `git`
- `amd-ucode` et `intel-ucode` (fixs du microcode CPU pour les processeurs AMD et Intel)

## Configuration custom
La commande `mp2i-install` va vous proposer un "Custom Desktop Environment", soit une configuration de bureau. Il est vivement recommendé de l'utiliser sans quoi seul un terminal vide sera présent après le reboot et il vous faudra tout installer à la main.

### Bootloader
Un thème sera appliqué à GRUB pour le rendre joli, le fichier de configuration du thème se trouve dans `/boot/grub/themes/mp2i` après installation. Le fond d'écran utilisé par défaut est :

![Image par défaut](https://github.com/MP2I-champo/MP2Arch/blob/main/airootfs/root/grub-config/mp2i/background.png)

### Login manager
Le login manager utilisé ici est `ly`, automatiquement configuré avec une animation du [jeu de la vie](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) de John Conway. Il est possible de modifier la configuration de `ly` en éditant le fichier `/etc/ly/config.ini` après installation.

![Login Manager](https://github.com/MP2I-champo/MP2Arch/blob/main/doc/ly.png)

### Window manager 
Packages :
- `hyprland` -> ce qui gère l'affichage des application et l'écran en général
- `quickshell` -> ce qui permet d'avoir la barre avec l'heure et des infos système
- `fuzzel` -> ouvrable avec Super + R (usuellement Super = touche windows) et permet d'ouvrir des applications
- `wpaperd` -> gère le fond d'écran et le change régulièrement
- `matugen` -> permet de générer des fichiers de configuration pour les autres packages avec des couleurs adaptées à une image
- utilitaires (voir le script `custom-config`)

![Window manager](https://github.com/MP2I-champo/MP2Arch/blob/main/doc/wm.png)

### Shell

![Shell](https://github.com/MP2I-champo/MP2Arch/blob/main/doc/shell.png)

### Bluetooth
### Audio
### Wifi
### Explorateur de fichiers
### Éditeur de code
### Polices d'écriture
