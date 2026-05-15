export BASH_SILENCE_DEPRECATION_WARNING=1
if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

if [ -e /home/afonsomanata/.nix-profile/etc/profile.d/nix.sh ]; then . /home/afonsomanata/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
eval "$(/opt/homebrew/bin/brew shellenv)"
