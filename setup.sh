#!/usr/bin/env bash

#------------------------
# Install Apt Packages
#------------------------
setup_apt() {
    sudo apt update && sudo apt install -y \
        build-essential \
        cmake \
        curl \
        git \
        vim \
        neovim \
        python-is-python3 \
        openssh-server \
        openssh-client \
        tmux \
        alsa-tools \
        pulseaudio-utils \
        pavucontrol \
        libnotify-bin \
        htop \
        maim \
        flameshot \
        feh \
        locate \
        acpi \
        rofi \
        shellcheck \
        brightnessctl \
        silversearcher-ag \
        xclip \
        pv
}

#------------------------
# Install Other Packages
#------------------------

setup_regolith_ubuntu22() {
    wget -qO - https://regolith-desktop.org/regolith.key | \
    gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null

    echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://regolith-desktop.org/release-3_2-ubuntu-jammy-amd64 jammy main" | \
    sudo tee /etc/apt/sources.list.d/regolith.list

    sudo apt update
    sudo apt install regolith-desktop regolith-session-flashback regolith-look-lascaille
}

# Tailscale
# https://tailscale.com/download
setup_tailscale() {
    curl -fsSL https://tailscale.com/install.sh | sh

    ## Authenticate
    # sudo tailscale up
    ## Show Tailscale IP
    # ip addr show tailscale0 
}

# Rust
# https://www.rust-lang.org/tools/install
setup_rust() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

# Nim
# https://github.com/dom96/choosenim#unix
setup_nim() {
    curl https://nim-lang.org/choosenim/init.sh -sSf | sh
}

# SBCL
# https://lisp-lang.org/learn/getting-started/
setup_sbcl() {
    # sudo apt install sbcl
    return 1
}

# Guile
# https://www.gnu.org/software/guile/download/
setup_guile() {
    # sudo apt install guile-3.0
    return 1
}

# Dr. Racket (just handle in Docker?)
# sudo add-apt-repository ppa:plt/racket && sudo apt update && sudo apt install racket

# Haskell
# https://docs.haskellstack.org/en/stable/install_and_upgrade/#ubuntu
setup_haskell() {
    # sudo apt install stack -y && stack upgrade
    return 1
}

# keybase
## Still kind of an unresolved issue: adding a new device on OS reinstall
setup_keybase() {
    # curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
    # sudo apt install ./keybase_amd64.deb
    # run_keybase
    return 1
}

# Docker
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
setup_docker() {
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    # Check if Docker installation succeeded
    # sudo docker run hello_world
}

# croc
# https://github.com/schollz/croc
setup_croc() {
    curl https://getcroc.schollz.com | bash
}

# nix
# https://nixos.org/download.html
setup_nix() {
    curl -L https://nixos.org/nix/install | sh
}
# Chrome

#------------------------
# Link .dotfiles
#------------------------

## Shamelessly taken from https://github.com/tomnomnom/dotfiles/blob/master/setup.sh

dotfilesDir=$(pwd)

function link_dotfile {
  target="$1"
  dest_dir="$2"
  dest="$dest_dir/$target"
  dateStr=$(date +%Y-%m-%d-%H%M)

  if [ -h "$dest" ]; then
    # Existing symlink 
    echo "Removing existing symlink: $dest"
    rm "$dest"

  elif [ -f "$dest" ]; then
    # Existing file
    echo "Backing up existing file: $dest"
    mv "$dest" "$dest.$dateStr"

  elif [ -d "$dest" ]; then
    # Existing dir
    echo "Backing up existing dir: $dest"
    mv "$dest" "$dest.$dateStr"
  fi

  echo "Creating new symlink: $dest"
  ln -s "$dotfilesDir/$target" "$dest"
}

link_dotfiles() {
    link_dotfile .vimrc "$HOME"
    link_dotfile .bashrc "$HOME"
    link_dotfile .config "$HOME"
}

setup_dotfiles() {
    git submodule update --init --recursive

    link_dotfiles
}

setup_vim() {
    mkdir -p "$dotfilesDir/.vim/bundle"
    cd "$dotfilesDir/.vim/bundle" || exit 1
    git clone http://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall

    sudo apt install -y \
        neovim \
        nodejs \
        npm
    mkdir "$HOME/.npm-global"
    npm config set prefix "$HOME/.npm-global"
}

setup_sdkman() {
    curl -s "https://get.sdkman.io" | bash
}

#------------------------------------
do_thing() {
    case $1 in
        regolith|--regolith)
            echo "Installing Regolith"
            setup_regolith_ubuntu22
            ;;
        apt|--apt)
            echo "Installing Apt Packages"
            setup_apt
            ;;
        rust|--rust)
            echo "Installing Rust"
            setup_rust
            ;;
        nim|--nim)
            echo "Installing Nim"
            setup_nim
            ;;
        tailscale|--tailscale)
            echo "Installing Tailscale"
            setup_tailscale
            ;;
        docker|--docker)
            echo "Installing Docker"
            setup_docker
            ;;
        sdkman|--sdkman)
            echo "Installing sdkman"
            setup_sdkman
            ;;
        croc|--croc)
            echo "Installing croc"
            setup_croc
            ;;
        nix|--nix)
            echo "Installing Nix"
            setup_nix
            ;;
        dotfiles|--dotfiles)
            echo "Setting up dotfiles"
            setup_dotfiles
            link_dotfiles
            ;;
        vim|--vim)
            echo "Setting up vim"
            setup_vim
            ;;
            *)
            echo "Unsupported argument: \"$1\""
            ;;
    esac
}

echo "-----------------------"
echo "Jeremy's computer setup"
echo "-----------------------"
if [ -z "$*" ]
then
    echo "Nothing to do"
else
    for thing in "$@"
    do
        do_thing "$thing"
    done
fi
#------------------------------------
