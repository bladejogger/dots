# V bg fg LV DV DM
PROMPT="%F{#DFC3BA}%n%f@%F{#AE6851}%m%f %~ %# "
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt notify
# End of lines configured by zsh-newuser-install
setopt APPEND_HISTORY
setopt SHARE_HISTORY

# vi mode for ZshLineEditor
bindkey -v

alias grep='grep --color'
alias lock="~/.scripts/random_lockscreen_image.sh"
alias ls='ls --color'
alias ll='ls -lFAh'   # "l"ong - "F"classify type - "A"ll(no '.') - "h"uman readable
alias lt='ls -lFAhtr' # ll but sort by "t"ime in "r"everse
alias obsidian="flatpak run md.obsidian.Obsidian &"
alias redo='sudo !!'
alias tree='tree -Cash --du'
alias whach='ldconfig -p | grep -i '

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "${terminfo[kcuu1]}" history-beginning-search-backward-end
bindkey "${terminfo[kcud1]}" history-beginning-search-forward-end

export RANGER_LOAD_DEFAULT_RC=false
export EDITOR=vim
