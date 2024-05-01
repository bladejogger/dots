#!/bin/bash

# error out
set -e

# debugging on (prints statements before executing them)
# set -x
# debugging off
# set +x

# check syntax but don't execute
# set -n

declare -a extra_array=("cifs-utils")

declare -a apt_array=("cmake" "feh" "ffmpeg" "flatpak" "gimp" "git" "htop" "i3" "i3blocks" "iw" \
    "libreoffice" "imagemagick" "lm-sensors" "mat2" "nautilus" "ncal" "neofetch" "nmap" "npm" \
    "pavucontrol" "pinta" "python3-pip" "python3-venv" "ranger" "rsync" "rxvt-unicode" "scrot" \
    "testdisk" "texlive-latex-extra" "tree" "vim" "vlc" "xchm" "zathura" "zsh")

declare -a pip_array=("build" "setuptools" "wheel")

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
        echo "[+] apt array: $packages"
        echo "[+] apt array installed"
    else
        echo "[-] failed apt array installation"
        exit
    fi

    read -p "[y/N] autoremove packages? " autorem_flag
    case "$autorem_flag" in
        [yY]|[yY][eE][sS])
            sudo apt autoremove -y
            echo "[+] extra packages removed"
            ;;
        *)
            echo "[ ] extras packages ignored"
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

declare -a repo_home_dir_files=("vim" "vimrc.conf" "xinitrc.conf" \
    "xprofile.conf" "serverrc.conf")

declare -a repo_home_config_dir_dirs=("i3blocks" "ranger" "ricemood")

config_stoof() {
    echo "--------------------------"
    echo "[ ] beginning configuration"

    REPO_CONFIG_DIR_0="$PWD"/configs/home_dir_configs
    REPO_CONFIG_DIR_1="$PWD"/configs/home_config_dir_configs
    LOCAL_CONFIG_DIR="$HOME"./config

    echo "[ ] installing ricemood"
    if npm install -g "$PWD"/ricemood_git_repo; then
        echo "[+] ricemood installed"
        echo "[ ]"
    else
        echo "[-] failed ricemood installation"
        exit
    fi

    echo "[ ] normalizing zsh"
    if chsh -s $(which zsh); then
        echo "[+] zsh normalized"
        echo "[ ]"
    else
        echo "[-] failed to use zsh"
        exit
    fi

    echo "[ ] moving X files and vim to $HOME"
    for i in ${repo_home_dir_files[@]};
    do
        cp -r "$REPO_CONFIG_DIR_0"/"$i" "$HOME"
    done
    echo "[+] moved X files and vim to $HOME"

    echo "[ ] moving config dirs to $HOME"
    chmod u+x "$REPO_CONFIG_DIR_1"/ranger/scope.sh
    for j in ${repo_home_config_dir_dirs[@]};
    do
        cp -r "$REPO_CONFIG_DIR_1"/"$j" "$HOME"
    done
    echo "[+] moved config dirs to $HOME"

    echo "[ ]"
    echo "[+] configuration complete"
    echo "--------------------------"
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
    echo "[ ] chmod'ing scripts"
    SCRIPTS_DIR="$PWD"/scripts
    for $i in "$SCRIPTS_DIR";
        do
            chmod u+x $i
        done
    echo "[+] scripts chmod'ed"

    echo "[ ] mv'ing scripts"
    cp -r "$SCRIPTS_DIR" "$HOME"
    echo "[+] scripts mov'ed"
}

menu() {
    echo "fresh setup"
    echo "[1] apt update and array install"
    echo "[2] pip update and array install"
    echo "[3] confs put into place"
    echo "[4] git name and email set"
    echo "[5] scripts put into place"
    echo "[6] 1-5, inclusive"
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
                script_stoof
                ;;
            "6")
                apt_stoof
                pip_stoof
                config_stoof
                git_stoof
                script_stoof
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
