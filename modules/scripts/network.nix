{ pkgs, ... }:
pkgs.writeShellScriptBin "network" ''
RED='\033[1;31m'
RST='\033[0m'

TIMEOUT=5

get-network-list() {
	nmcli device wifi rescan 2> /dev/null

	local i
	for ((i = 1; i <= TIMEOUT; i++)); do
		printf '\rScanning for networks...'

		list=$(timeout 1 nmcli device wifi list)
		networks=$(tail -n +2 <<< "$list" | awk '$2 != "--"')

		[[ -n $networks ]] && break
	done

	printf '\n%bScanning Finished.%b\n\n' "$RED" "$RST"

	if [[ -z $networks ]]; then
    notify-send "Wi-Fi" -e -t 2500 -u low "No networks found" -i "package-broken"
    tput cnorm
		return 1
	fi
}

select-network() {
	local header
	header=$(head -n 1 <<< "$list")

	# shellcheck disable=SC1090

	local opts=(
		--border=sharp
		--border-label=' Wi-Fi Networks '
		--ghost='Search'
		--header="$header"
		--height=~100%
		--highlight-line
		--info=inline-right
		--pointer=
		--reverse
	)

	bssid=$(fzf "''${opts[@]}" <<< "$networks" | awk '{print $1}')

	if [[ -z $bssid ]]; then
		return 1
	elif [[ $bssid == '*' ]]; then
    notify-send "Wi-Fi" -e -t 2500 -u low "Already connected to this network" \
			-i 'package-install'
		return 1
	fi
}

connect-to-network() {
	printf 'Connecting...\n'

  nmcli --ask device wifi connect "$bssid"
	if nmcli --ask device wifi connect "$bssid"; then
    return
    # notify-send "Wi-Fi" -e -t 2500 -u low "Successfully connected" -i "package-install"
	else
    notify-send "Wi-Fi" -e -t 2500 -u low "Failed to connect" -i "package-purge"
	fi
}

main() {
	local status
	status=$(nmcli radio wifi)

	if [[ $status == 'disabled' ]]; then
		nmcli radio wifi on
    notify-send "Wi-Fi Enabled" -e -t 2500 -u low -r 1125 -i "network-wireless-on"
	fi

	tput civis # make cursor invisible
	get-network-list || exit 1
	tput cnorm # make cursor visible

	select-network || exit 1
	connect-to-network
}

main
''
