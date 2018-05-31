#!/bin/bash
for file in ~/.{bash_prompt,aliases,functions,dockerfunc,extra}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		source "$file"
	fi
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# tab competion for vpn alias
[[ $(ls -1 ~/vpn/*.ovpn 2>/dev/null) ]] && complete -o "default" -o "nospace" -W "$(find ~/vpn/*.ovpn -printf "%f\n")" vpn

# kubectl tab completion
type kubectl 2>/dev/null && source <(kubectl completion bash)
type oc 2>/dev/null && source <(oc completion bash)
type openstack 2>/dev/null && source <(openstack complete)

# golang env
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH:$GOBIN:/usr/local/go/bin
