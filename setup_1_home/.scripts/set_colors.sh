#!/usr/bin/zsh

cd ~/.config/ricemood
printf "Y\n" | ricemood -a
source ~/.zshrc
xrdb -merge ~/.Xresources
i3-msg reload
