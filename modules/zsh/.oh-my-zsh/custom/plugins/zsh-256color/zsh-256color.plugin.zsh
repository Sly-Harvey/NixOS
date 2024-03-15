# Copyright (c) 2014-2019, Christian Ludwig
#
# Set 256color terminal mode if available.


_zsh_256color_debug()
{
	[[ -n "${ZSH_256COLOR_DEBUG}" ]] && echo "zsh-256color: $@" >&2
}

_zsh_terminal_set_256color()
{
	if [[ "$TERM" =~ "-256color$" ]] ; then
		_zsh_256color_debug "256 color terminal already set."
		return
	fi

	local TERM256="${TERM}-256color"

	# Use (n-)curses binaries, if installed.
	if [[ -x "$( which toe )" ]] ; then
		if toe -a | grep -E "^$TERM256" >/dev/null ; then
			_zsh_256color_debug "Found $TERM256 from (n-)curses binaries."
			export TERM="$TERM256"
			return
		fi
	fi

	# Search through termcap descriptions, if binaries are not installed.
	for termcaps in $TERMCAP "$HOME/.termcap" "/etc/termcap" "/etc/termcap.small" ; do
		if [[ -e "$termcaps" ]] && grep -E -q "(^$TERM256|\|$TERM256)\|" "$termcaps" ; then
			_zsh_256color_debug "Found $TERM256 from $termcaps."
			export TERM="$TERM256"
			return
		fi
	done

	# Search through terminfo descriptions, if binaries are not installed.
	for terminfos in $TERMINFO "$HOME/.terminfo" "/etc/terminfo" "/lib/terminfo" "/usr/share/terminfo" ; do
		if [[ -e "$terminfos"/$TERM[1]/"$TERM256" || \
				-e "$terminfos"/"$TERM256" ]] ; then
			_zsh_256color_debug "Found $TERM256 from $terminfos."
			export TERM="$TERM256"
			return
		fi
	done
}

_zsh_terminal_set_256color
unset -f _zsh_terminal_set_256color
unset -f _zsh_256color_debug
