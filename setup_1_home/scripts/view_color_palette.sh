#!/usr/bin/zsh

for code in {000..255}; do
    print -P -- "$code: %F{$code}Color%f";
done

# /bin/bash
#for code in {0..255}; do
#    echo -e "\e[38;05;${code}m $code: Color";
#done
