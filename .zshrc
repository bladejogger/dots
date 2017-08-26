# prompt style
# $USERNAME@hostname pwd
PROMPT="
%F{8A7A63}%n%f@%F{9ED9D8}%m%f %B%F{065F73}%2~%f%b
%# "

# history
setopt APPEND_HISTORY
setopt SHARE_HISTORY
#
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# aliases
alias ls='ls --color'
alias ll='ls -lFA'
alias grep='grep --color'
alias chrome='(chromium --incognito &)'
alias doc='(libreoffice &)'
alias redo='sudo !!'
alias lock='i3lock -i [path to image] -e -f'

# history searching
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
