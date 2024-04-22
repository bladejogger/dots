#!/bin/bash

# error out
set -e

# debugging on (prints statements before executing them)
# set -x
# debugging off
# set +x

# check syntax but don't execute
# set -n

apt_array = ("cmake" "feh" "ffmpeg" "flatpak" "gimp" "git" "htop" "i3" \
    "i3blocks" "libreoffice" "imagemagick" "mat2" "nautilus" "ncal" \
    "neofetch" "nmap" "pavucontrol" "pinta" "python3-pip" "python3-venv" \
    "ranger" "rxvt-unicode" "scrot" "testdisk" "texlive-latex-extra" \
    "tree" "vim" "vlc" "xchm" "zathura" "zsh")

pip_array = ("build" "setuptools" "wheel")

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
            echo "[ ] extras remain"
            ;;
    esac
}

pip_stoof() {
    python3 -m pip install --upgrade
    echo "[ ] installing pip array"
    if python3 -m pip install 0U ${pip_array[@]}; then
        echo "[+] pip array installed"
    else
        echo "[-] failed pip array"
        exit
    fi

}

config_stoof() {
    echo "[ ] cloning ricemood"
    git clone https://github.com/f0x48/ricemood.git
    echo "[+] ricemood cloned"

    chsh -s $(which zsh)

    read -p "git name? (Enter to skip) " git_name
    read -p "git email? (Enter to skip) " git_email
    if [ "" == "$git_name" ]; then
        echo "[ ] empty git name; aborting"
        exit
    elif [ "" == "$git_email" ]; then
        echo "[ ] empty git email; aborting"
        exit
    fi

    # chmod +x ranger/scope.sh
}

git_stoof() {
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

menu() {
    echo "fresh setup"
    echo "[1] apt"
    echo "[2] pip"
    echo "[3] confs"
    echo "[4] 0, 1, 2"
    echo "[0] exit"
}

menu()

while read -p "> " user_in;
do
    echo ""
    case $user_in in
        "1")
            apt_stoof()
            ;;
        "2")
            pip_stoof()
            ;;
        "3")
            config_stoof()
            ;;
        "4")
            apt_stoof()
            pip_stoof()
            config_stoof()
            ;;
        "0")
            echo "goodbye"
            exit
        *)
            ;;
    esac
    echo ""
    menu()
done
