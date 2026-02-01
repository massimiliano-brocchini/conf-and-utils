HISTSIZE=8000
SAVEHIST=8000
HISTFILE=~/.zsh_history

# {{{ modules
# TAB completion
autoload -U compinit
compinit

#CTRL + up / down arrow 
autoload up-line-or-beginning-search 	
zle -N up-line-or-beginning-search 	
autoload down-line-or-beginning-search 
zle -N down-line-or-beginning-search 

# automatic URL quoting
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
# }}}

unset FLOW_CONTROL # disable ^Q e ^S
# stop showing message "no match found" and passing the arguments to the command instead
# should be configured like that to avoid this kind of message on composed commands like "watch (ls | grep x)"
setopt NONOMATCH 

#history
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

setopt CORRECT
setopt INTERACTIVE_COMMENTS

#completion
setopt AUTO_LIST			# show possible completions in a list if there are more than one possibilities
setopt LISTTYPES            # show types in completion
setopt COMPLETEINWORD       # not just at the end
setopt EXTENDEDGLOB			# more than simple * (e.g. ^bak gets expanded to * minus *bak)

#directory stack
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

#completion on ..
zstyle ':completion:*:*:*' special-dirs ..
#add completion on global aliases (e.g. ..2 TAB -> ../..)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' completer _expand _expand_alias _complete 


limit core 0
limit coredumpsize 0

PROMPT='[%n@%m]$ '    # left prompt
RPROMPT=' [%~]'    # right prompt


bindkey "\e[H" 	beginning-of-line		#Home
bindkey "\e[F" 	end-of-line				#End
bindkey "\eOH" 	beginning-of-line		#Home
bindkey "\eOF" 	end-of-line				#End
bindkey "^[[H" 	beginning-of-line		#Home
bindkey "^[[F" 	end-of-line				#End
bindkey "^[[3~"	delete-char				#Del
bindkey "^?" 	backward-delete-char	#Backspace

bindkey "^[[5~" beginning-of-history 	#Page Up
bindkey "^[[6~" end-of-history 			#Page Down

# search entries in the history beginning with the characters written before the cursor
bindkey "^[[1;5A" up-line-or-beginning-search 	#CTRL + up arrow
bindkey "^[[1;5B" down-line-or-beginning-search 	#CTRL + down arrow

bindkey "^[[1;5D" backward-word 	#CTRL + left arrow 
bindkey "^[[1;5C" forward-word 		#CTRL + right arrow

# da specificare per via dei binding VI like
bindkey '^R'    history-incremental-search-backward
bindkey '^F'    history-incremental-search-forward
bindkey '^K'	kill-line 
bindkey "^A" 	beginning-of-line
bindkey "^E" 	end-of-line

bindkey "^[[Z"  reverse-menu-complete

# set aside what we are working on to lunch a command and then restart from where we left off (no more # at the beginning of line if we forgot to run a command before the one we are writing)
bindkey '^P'	push-line 

# change current line(s) in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^[e' edit-command-line	#ALT + E

# remove the current line from the history file (need to add remove-line-from-history under /usr/share/zsh/functions/Zle/)
autoload -U remove-line-from-history
zle -N remove-line-from-history
bindkey '^[[3;2~' remove-line-from-history #SHIFT + DEL

# reduced bindings for tty shells
case $TERM in 
 linux)
  bindkey "\e[1~" beginning-of-line
  bindkey "\e[4~" end-of-line
  bindkey "\e[3~" delete-char
  bindkey "^?" backward-delete-char
  bindkey '^R'    history-incremental-search-backward
  bindkey '^F'    history-incremental-search-forward
;;
esac

# {{{ aliases

#ls
alias ls='ls --color=auto -hs'
alias la='ls --color=auto -Ahs'
alias ll='ls --color=auto -lhs'
alias ld='ls --color=auto -d'
alias lsd='ls -d .*(/) *(/)'                  # only show directories

alias lsbig="ls -Slhr"      # display the biggest files
alias lsnew="ls -tlhr"      # display the newest files
alias lsold="ls -tlh"    # display the oldest files
alias lssmall="ls -Slh"    # display the smallest files

alias evince=atril

alias c='clear'
alias cd..='cd ..'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias psaux='ps auxww | grep -v grep | grep -i --color'
alias clean='find ./ -type f -iname "*~" -delete'
alias less='less -i' #less with smartcase search
alias d='dirs -v'
alias screenshot='import png:- | xclip -selection clipboard -t image/png'

alias halt='poweroff'
alias lua='rlwrap lua'

#more readable output
alias du='du -h'
alias df='df -h'
alias free='free -m'
alias grep='grep --color'

alias -g ...='../..'
alias -g ..2='../..'
alias -g ..3='../../..'
alias -g ..4='../../../..'
alias -g ..5='../../../../..'

#aliases works with sudo too (e.g. sudo ll)
alias sudo='nocorrect sudo '

#redo:
#use this when sudo is not enough (e.g. cd, piped commands, redirections)
if [ $EUID -eq 0 ]; then 
	alias redo="echo $(tail -10 ~$(echo $USER | cut -d ' ' -f 1)/.zsh_history | grep -v ';su' | tail -1 |cut -d ';' -f 2)"
fi

# }}}

# variables
test -n "$DISPLAY" && export TERM=xterm-256color
export LC_ALL="en_US.UTF-8"
export LC_PAPER="it_IT" #A4 paper format
export LESSCHARSET=utf-8 #no more errors in "man"
export EDITOR=vim
export VISUAL=vim
export OOO_FORCE_DESKTOP=gnome
export SUDO_PROMPT='password sudo:'

# dynamic window title
case $TERM in
         xterm*)
            precmd() { print -Pn "\e]0;%n@%m:%~\a" }
            preexec () { print -Pn "\e]0;${~1:gs/%/%%} %n@%m\a" }
            ;;
esac

# colorful ls output
eval `dircolors`


lowercase() {
	for file ; do
		filename=$(basename $file)
		dirname=$(dirname $file)
		nf=$(echo $filename | tr A-Z a-z)
		newname="${dirname}/${nf}"
		if [ "$nf" != "$filename" ]; then
			mv "$file" "$newname"
			echo "lowercase: $file --> $newname"
		else
			echo "lowercase: $file not changed."
		fi
	done
}

cd () {
	emulate -LR zsh
	setopt AUTO_PUSHD
	setopt PUSHD_IGNORE_DUPS

	if [[ -f $1 ]]; then
		builtin cd $1:h
	else
		builtin	cd $1
	fi
}

random-mpv() {
	d=${2:-.}
	video=$(find $d -maxdepth 1 -type f | sort -R | head -n $1)
	echo "$video"
	echo "$video" | parallel --no-notice --tty -Xj1 mpv --deinterlace --no-resume-playback
}

gitdiff() {
	vimdiff $1  <(git show HEAD:$1)
}

# X auto start
if [[ "$HOST" == "salotto" ]] && [[ -z "$DISPLAY" ]] && [[ $(tty) == /dev/tty1 ]] && [[ "`whoami`" != "root" ]]; then
	startx
fi

