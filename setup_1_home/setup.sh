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

# this will also update docker
declare -a docker_array=("ca-certificates" "curl" "docker-ce" "docker-ce-cli" "containerd.io" \
    "docker-buildx-plugin" "docker-compose-plugin")

declare -a apt_array=("cmake" "feh" "ffmpeg" "flatpak" "gimp" "git" "htop" "i3" "i3blocks" "iw" \
    "libreoffice" "imagemagick" "lm-sensors" "mat2" "nautilus" "ncal" "neofetch" "nmap" "npm" \
    "pavucontrol" "pinta" "python3-pip" "python3-venv" "ranger" "rsync" "rxvt-unicode" "scrot" \
    "testdisk" "texlive-latex-extra" "thunar" "tree" "vim" "vlc" "xchm" "zathura" "zsh")

declare -a pip_array=("build" "setuptools" "wheel")

apt_stoof()
{
    echo "--------------------------"
    echo "[ ] beginning apt update and installation"

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

    echo "[+] apt update and installation complete"
    echo "--------------------------"
}

pip_stoof()
{
    echo "--------------------------"
    echo "[ ] beginning pip upgrade and package installation"
    python3 -m pip install --upgrade
    echo "[ ] installing pip array"
    if python3 -m pip install --upgrade --user ${pip_array[@]}; then
        echo "[+] pip array installed"
    else
        echo "[-] failed pip array"
        exit
    fi
    echo "[+] pip upgrade and package installation complete"
    echo "--------------------------"
}

declare -a repo_home_config_dir_dirs=("i3blocks" "ranger" "ricemood")

config_stoof()
{
    echo "--------------------------"
    echo "[ ] beginning configuration"

    REPO_CONFIG_DIR_0="$PWD"/configs/home_dir_configs
    REPO_CONFIG_DIR_1="$PWD"/configs/home_config_dir_configs
    LOCAL_CONFIG_DIR="$HOME"./config

    echo "[ ] installing ricemood"
    if npm install -g "$PWD"/ricemood_git_repo; then
        echo "[+] ricemood installed"
        echo ""
    else
        echo "[-] failed ricemood installation"
        exit
    fi

    echo "[ ] normalizing zsh"
    if chsh -s $(which zsh); then
        echo "[+] zsh normalized"
        echo ""
    else
        echo "[-] failed to use zsh"
        exit
    fi

    echo "[ ] moving X files and vim to $HOME"
    cp -r "$REPO_CONFIG_DIR_0"/vim "$HOME"/.vim
    cp "$REPO_CONFIG_DIR_0"/inputrc.conf "$HOME"/.inputrc
    cp "$REPO_CONFIG_DIR_0"/vimrc.conf "$HOME"/.vimrc
    cp "$REPO_CONFIG_DIR_0"/xinitrc.conf "$HOME"/.xinitrc
    cp "$REPO_CONFIG_DIR_0"/xprofile.conf "$HOME"/.xprofile
    cp "$REPO_CONFIG_DIR_0"/xserverrc.conf "$HOME"/.serverrc
    echo "[+] moved X files and vim to $HOME"

    echo "[ ] moving config dirs to $HOME"
    chmod u+x "$REPO_CONFIG_DIR_1"/ranger/scope.sh
    for i in ${repo_home_config_dir_dirs[@]};
    do
        cp -r "$REPO_CONFIG_DIR_1"/"$i" "$HOME"/.config
    done
    echo "[+] moved config dirs to $HOME"

    echo ""
    echo "[+] configuration complete"
    echo "--------------------------"
}

git_stoof()
{
    echo "--------------------------"
    echo "[ ] beginning git configuration"
    read -p "git name? (Enter to skip) " git_name
    read -p "git email? (Enter to skip) " git_email
    if [ -z "$git_name" ]; then
        echo "[ ] empty git name; aborting"
        return
    elif [ -z "$git_email" ]; then
        echo "[ ] empty git email; aborting"
        return
    fi

    git config --global user.username $git_name
    git config --global user.email $git_email

    git config --global core.editor vim

    git config merge.tool vimdiff
    git config merge.style diff3
    git config merge.prompt false

    git config alias.logger "log --graph --abbrev-commit --decorate --format=format:\
        '%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) \
        %C(white)%s%C(reset) %C(dim white) - %an%C(reset)%C(auto)%d%C(reset)' --all"

    echo "[+] git configuration complete"
    echo "--------------------------"
}

scripts_on()
{
    echo "--------------------------"
    echo "[ ] beginning script modification and transfer"

    echo "[ ] chmod'ing scripts"
    SCRIPTS_DIR="$PWD"/scripts
    for $i in "$SCRIPTS_DIR";
        do
            chmod u+x $i
        done
    echo "[+] scripts chmod'ed"

    echo "[ ] mv'ing scripts"
    cp -r "$SCRIPTS_DIR" "$HOME"/.scripts
    echo "[+] scripts mov'ed"

    echo "[+] script modification and transfer complete"
    echo "--------------------------"
}

docker_stoof()
{
    echo "--------------------------"
    echo "[ ] beginning docker install and group configuration"

    for i in ${docker_array[@]};
        do
            if [ -z "$(apt-cache madison $i 2>/dev/null)" ]; then
                echo "[-] '$i' missing; skipping"
            else
                packages="$packages $i"
            fi
        done
    echo ""

    if sudo apt install -y "$packages"; then
        echo "[+] docker array: $packages"
        echo "[+] apt array installed"
    else
        echo "[-] failed docker array installation"
        exit
    fi
    echo ""

    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
        https://download docker.com/linux/ubuntu /etc/os-release && echo "$VERSION_CODENAME") " \
        | tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update

    sudo groupadd -f docker
    sudo usermod -aG docker $USER
    echo "[+] docker installed and $USER added to group"
    echo "--------------------------"
}

backlight_stoof()
{
    # acpilight_repo:
    # sudo make install
    # cp 90-backlight.rules /etc/udev/90-backlight.rules
    # chmod +x xbacklight
    # mv bin /usr/local/bin/xbacklight
}

menu()
{
    echo "[1] apt update and array install"
    echo "[2] pip update and array install"
    echo "[3] confs put into place"
    echo "[4] git name and email set"
    echo "[5] docker set up"
    echo "[6] scripts put into place"
    echo "[7] fix xbacklight crap"
    echo "[8] 1-7, inclusive"
    echo "[0] exit"
    echo "----------------------------"
}

echo "############################"
echo "##                        ##"
echo "##  fresh setup installer ##"
echo "##                        ##"
echo "############################"
echo ""
menu

while read -p ">> " user_in;
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
                docker_stoof
                ;;
            "6")
                script_stoof
                ;;
            "7")
                backlight_stoof
                ;;
            "8")
                apt_stoof
                pip_stoof
                config_stoof
                git_stoof
                docker_stoof
                script_stoof
                backlight_stoof
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
