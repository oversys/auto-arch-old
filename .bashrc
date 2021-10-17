#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

alias pd="sudo pacman -Syy"
alias psys="sudo pacman -Syyu"
ps() { sudo pacman -S $*; }
pr() { sudo pacman -R $*; }


(cat ~/.cache/wal/sequences &)
neofetch
