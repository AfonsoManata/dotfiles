# ===================================================================
# ALIASES
# ===================================================================
alias ls="eza --icons=always -a"
alias rm="rm -i"

# ===================================================================
# HISTORY SETTINGS (Sintaxe Bash)
# ===================================================================
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTFILE=~/.bash_history
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# ===================================================================
# PATH CONFIG
# ===================================================================
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# ===================================================================
# VI MODE (Nativo do Bash)
# ===================================================================
set -o vi
export EDITOR="nvim"
export VISUAL="nvim"

# ===================================================================
# FZF + FD + EZA + BAT + ZOXIDE
# ===================================================================
eval "$(zoxide init --cmd cd bash)"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export FZF_DEFAULT_OPTS="--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_zoxide_cd_final() {
	local dir
	dir=$(zoxide query -l | fzf --height 40% --layout=reverse)
	if [[ -n "$dir" ]]; then
		cd "$dir"
		clear
		kill -WINCH $$
	fi
}

bind -x '"\C-f": _fzf_zoxide_cd_final'

# ===================================================================
# NVM (Node Version Manager)
# ===================================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ===================================================================
# YAZI FILE MANAGER
# ===================================================================
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ===================================================================
# TMUX AUTO-ATTACH
# ===================================================================
# Auto-attach to tmux if not already inside
# Only run this if we are in an interactive shell and NOT already inside tmux
if [[ $- == *i* ]] && [ -z "$TMUX" ] && command -v tmux &>/dev/null; then

	# Create the trio in the background if they don't exist
	tmux has-session -t work 2>/dev/null || tmux new-session -d -s work
	tmux has-session -t project 2>/dev/null || tmux new-session -d -s project
	tmux has-session -t random 2>/dev/null || tmux new-session -d -s random

	# Attach to 'random' by default
	exec tmux -2 attach-session -t random
fi

tmux source-file ~/.tmux/.tmux.conf
eval "$(fzf --bash)"
eval "$(starship init bash)"
PS1="$PS1\[\e[38;2;68;255;177m\]"
