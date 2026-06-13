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
- Setup de `iwd` et `systemd` pour pouvoir se connecter à internet après l'installation
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

### Package manager
`paru` est automatiquement installé (c'est un wrapper de `pacman`), il permet l'installation de packages depuis l'AUR (Arch User Repository).

Commandes courantes :
- `paru` -> update les databases et met à jour tous les packages
- `paru -S <package>` -> installe `<package>`
- `paru -R <package>` -> désinstalle `<package>`

### Bootloader
Un thème sera appliqué à GRUB pour le rendre joli, le fichier de configuration du thème se trouve dans `/boot/grub/themes/mp2i` après installation. Le fond d'écran utilisé par défaut est :

![Image par défaut](https://github.com/MP2I-champo/MP2Arch/blob/main/airootfs/root/grub-config/mp2i/background.png)

### Login manager
Le login manager utilisé ici est `ly`, automatiquement configuré avec une animation du [jeu de la vie](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) de John Conway. Il est possible de modifier la configuration de `ly` en éditant le fichier `/etc/ly/config.ini` après installation.

![Login Manager](https://github.com/MP2I-champo/MP2Arch/blob/main/doc/ly.png)

### Window manager 
Packages :
- `hyprland` -> ce qui gère l'affichage des application et l'écran en général
- `quickshell` -> ce qui affiche la barre avec les informations sur le haut de l'écran
- `fuzzel` -> ouvrable avec Super + R (usuellement Super = touche windows) et permet d'ouvrir des applications
- `wpaperd` -> gère le fond d'écran et le change régulièrement
- `matugen` -> permet de générer des fichiers de configuration pour les autres packages avec des couleurs adaptées à une image
- utilitaires (voir le script `custom-config`)

Le dossier où vous pouvez ajouter / enlever des fonds d'écran est `~/wallpapers`. Le fichier de configuation de `wpaperd` est `~/.config/waperd/config.toml`. Pour lui faire changer le thème au changement de fond d'écran il faut décommenter le code dans `~/.config/wpaperd/matugen-hook.sh`.

![Window manager](https://github.com/MP2I-champo/MP2Arch/blob/main/doc/wm.png)

### Shell
Packages :
- `zsh-autosuggestions`, `zsh-syntax-highlighting` et `zsh-history-substring-search` -> plugins zsh pour avoir des suggestions, de la coloration et une meilleure recherche dans le terminal
- `alacritty` -> terminal utilisé
- `starship` -> gère le prompt avec l'username / le répertoire actuel... (peut aussi afficher des informations liées à git et autres)

![Shell](https://github.com/MP2I-champo/MP2Arch/blob/main/doc/shell.png)

### Bluetooth
Packages :
- `bluez` et `bluez-utils` (permettent l'utilisation du bluetooth)
- `bluetui` -> TUI (Terminal User Interface) permettant de gérer le bluetooth

### Audio
Packages :
- `pipewire`, `pipewire-audio` et `wireplumber` -> permettent de faire fonctionner le son
- `pipewire-pulse` et `pipewire-jack` -> plugins de pipewire pour permettre la compatibilité avec d'autres protocoles audio
- `wiremix` -> TUI pour gérer le son

### Wifi
Packages :
- `iwd` et `systemd` (comme expliqué plus haut, permettent l'utilisation du wifi / d'internet en général)
- `impala` -> TUI permettant de gérer le wifi

### Explorateur de fichiers
Yazi est installé, c'est un explorateur de fichiers qui fonctionne dans le terminal (TUI).

### Éditeur de code
[Helix](https://helix-editor.com/) est installé par le script et automatiquement configuré (voir `~/.config/helix` pour les fichiers de configuration), un shortcut est aussi automatiquement mis en place et permet d'ouvrir `helix` via la commande `hx`.

Pour installer des lsp (language support protocol) permettant d'avoir des fonctionalités telles que l'autodétection d'erreurs, vous pouvez utiliser `hx --health` et utiliser `paru` pour installer le package correspondant au langage souhaité.

### Polices d'écriture
La police `jetbrains-mono-nerd` est utilisée par le terminal, les polices `noto-fonts` et `noto-fonts-emoji` sont là en complément pour supporter un maximum de caractères.

### Outils de développement pour MP2I
Si vous avez sélectionné l'installation du Desktop Environment, le script va vous proposer d'installer `clang` (un compilateur C très pratique durant l'année) et `opam`, le package manager des packages `ocaml`, qui vous permettra notamment d'installer `utop`.

`opam` nécessite un peu de configuration :
- depuis votre terminal une fois l'installation finie (et après reboot...), exécutez `opam init`
- puis `opam update`
- enfin, exécutez `opam install utop` pour installer utop

### LaTeX & Typst
Leur installation est encore une fois proposée si vous avez choisi le Desktop Environment.

LaTeX et Typst sont deux "langages" utilisés pour créer des documents textes. Ils ne sont pas obligatoires non plus et ne vous serviront pas forcément (LibreOffice est une bonne alternative si vous ne voulez pas perdre votre temps...).

LaTeX est le "standard" pour les documents scientifiques et Typst bien que plus jeune se répand.

Pour LaTeX, si sélectionné le script installe TexStudio, un éditeur fait pour LaTeX très pratique.

### Autres
Firefox est installé pour permettre de naviguer sur le web.

L'outil `brightnessctl` est installé pour facilement changer la luminosité.
