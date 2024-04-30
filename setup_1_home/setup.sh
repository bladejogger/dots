#!/bin/bash

# error out
set -e

# debugging on (prints statements before executing them)
# set -x
# debugging off
# set +x

# check syntax but don't execute
# set -n

extra_array=("cifs-utils")

apt_array=("cmake" "feh" "ffmpeg" "flatpak" "gimp" "git" "htop" "i3" \
    "i3blocks" "iw" "libreoffice" "imagemagick" "lm-sensors" "mat2" \
    "nautilus" "ncal" "neofetch" "nmap" "npm" "pavucontrol" "pinta" \
    "python3-pip" "python3-venv" "ranger" "rsync" "rxvt-unicode" "scrot" \
    "testdisk" "texlive-latex-extra" "tree" "vim" "vlc" "xchm" "zathura" "zsh")

pip_array=("build" "setuptools" "wheel")

apt_stoof() {
    echo "[ ] updating apt"
    sudo apt update
    echo "[+] apt updated"

    echo "[ ] installing apt array"
    for i in ${apt_array[@]};
        do
            if [ -z "$(apt-cache madison $i 2>/dev/null)" ]; then
                echo "[-] '$i' missing; skipping"
            else
                packages="$packages $i"
            fi
        done
    echo ""
    if sudo apt install -y "$packages"; then
        echo "[+] apt array installed"
    else
        echo "[-] failed apt array installation"
        exit
    fi

    read -p "[y/N] autoremove packages? " autorem
    case "$autorem" in
        [yY]|[yY][eE][sS])
            sudo apt autoremove -y
            echo "[+] extras removed"
            ;;
        *)
            echo "[ ] extras ignored"
            ;;
    esac
}

pip_stoof() {
    python3 -m pip install --upgrade
    echo "[ ] installing pip array"
    if python3 -m pip install -U ${pip_array[@]}; then
        echo "[+] pip array installed"
    else
        echo "[-] failed pip array"
        exit
    fi

}

config_stoof() {
    CONFIG_DIR_0="$PWD"/configs
    CONFIG_DIR_1="$PWD"/configs/config
    CONFIG_DIR_2="$HOME"./config
    CONFIG_DIR_3="$HOME"./config/ricemood
    echo "[ ] installing ricemood"
    #git clone https://github.com/f0x48/ricemood.git
    npm install -g "$PWD"/ricemood_git_repo
    echo "[+] ricemood installed"

    echo "[ ] normalizing zsh"
    chsh -s $(which zsh)
    cp "$CONFIG_DIR_0"/zshrc.conf "$CONFIG_DIR_2"/zshrc.conf
    echo "[+] zsh normalized"

    echo "[ ] moving i3 conf"
    cp "$CONFIG_DIR_0"/i3.conf "$CONFIG_DIR_2"/i3.conf
    echo "[+] i3 conf moved"

    echo "[ ] moving i3blocks..."
    cp -r "$CONFIG_DIR_1"/i3blocks "$CONFIG_DIR_2"
    echo "[+] i3blocks moved"

    echo "[ ] moving ranger confs"
    chmod u+x "$CONFIG_DIR_1"/ranger/scope.sh
    cp -r "$CONFIG_DIR_1"/ranger "$CONFIG_DIR_2"
    echo "[+] ranger confs moved"

    echo "[ ] moving vim templates and conf"
    cp -r "$CONFIG_DIR_1"/vim "$CONFIG_DIR_2"
    cp $"CONFIG_DIR_0"/vimrc.conf "$HOME"
    echo "[+] vim templates and conf moved"

    echo "[ ] moving X confs"
    cp "$CONFIG_DIR_0"/xinitrc.conf "$HOME"
    cp "$CONFIG_DIR_0"/xprofile.conf "$HOME"
    cp "$CONFIG_DIR_0"/xserverrc.conf "$HOME"
    echo "[+] X confs moved"
}

git_stoof() {
    read -p "git name? (Enter to skip) " git_name
    read -p "git email? (Enter to skip) " git_email
    if [ "" == "$git_name" ]; then
        echo "[ ] empty git name; aborting"
        exit
    elif [ "" == "$git_email" ]; then
        echo "[ ] empty git email; aborting"
        exit
    fi

    git config --global user.username $git_name
    git config --global user.email $git_email

    git config --global core.editor vim

    git config merge.tool vimdiff
    git config merge.style diff3
    git config merge.prompt false

    git config alias.logger log --graph --abbrev-commit --decorate --format=format:\
        '%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) \
        %C(white)%s%C(reset) %C(dim white) - %an%C(reset)%C(auto)%d%C(reset)' --all
}

scripts_on() {
    SCRIPTS_DIR="$PWD"/scripts
    for $i in "$SCRIPTS_DIR";
        do
            chmod u+x $i
        done

}

menu() {
    echo "fresh setup"
    echo "[1] apt update and array install"
    echo "[2] pip update and array install"
    echo "[3] confs put into place"
    echo "[4] git name and email set"
    echo "[5] 1, 2, 3, 4"
    echo "[0] exit"
}

menu

while read -p "> " user_in;
    do
        echo ""
        case "$user_in" in
            "1")
                apt_stoof
                ;;
            "2")
                pip_stoof
                ;;
            "3")
                config_stoof
                ;;
            "4")
                git_stoof
                ;;
            "5")
                apt_stoof
                pip_stoof
                config_stoof
                ;;
            "0")
                echo "goodbye"
                exit
                ;;
            *)
                echo "invalid input"
                exit
                ;;
        esac
        echo ""
        menu
    done
