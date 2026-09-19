#!/bin/sh

#  pimp-login
#  ----------
#  Source is licensed under MIT License. Refer to LICENSE file for details.

_except=0
_sys="$(uname -s | tr '[:upper:]' '[:lower:]')"

if ! grep -E '^ID=debian' /etc/os-release >/dev/null 2>&1
then
	printf 'pimp-login: not running from debian linux\n' >&2
	exit 2
fi

if [ "$(tty 2>/dev/null)" != "/dev/tty1" ]
then
	exit 2
fi

if ! command -v pimp >/dev/null 2>&1
then
	printf 'pimp-login: pimp not found\n' >&2
	_except=1
fi

if ! command -v pimp >/dev/null 2>&1
then
	printf 'pimp-login: pimp not found\n' >&2
	_except=1
fi

if ! command -v tmux >/dev/null 2>&1
then
	printf 'pimp-login: tmux not found\n' >&2
	_except=1
fi

if pgrep -x pimp >/dev/null 2>&1
then
	printf 'pimp-login: other pimp process(es) running\n' >&2
	_except=1
fi

if [ -n "$TMUX" ]
then
	printf 'pimp-login: not running from outside tmux session\n' >&2
	_except=1
fi

if [ ${_except} -eq 1 ]
then
	exit 2
fi

if command -v wpctl >/dev/null 2>&1
then
	wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.80
fi

clear

while true
do
	pimp splash
	tmux new-session -s 'pimp' -d 'pimp -b' 2>/dev/null
	tmux set -g status off
	tmux -2 attach
done

