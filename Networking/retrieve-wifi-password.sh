#!/bin/bash

# Description: 
#   Lists all saved wifi networks and retrieves passwords
#   for the stored networks.
#
# Note: "pretty" error handling is incomplete


usage(){
cat <<EOF

Pass the SSID of the network you'd like the password of.
Or don't pass anything for the current network.

	Usage: appname [ssid]

EOF
}

if [[ "$1" = "help" ]]; then
	usage
	exit 1
fi

#airport executable
airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
if [ ! -f $airport ]; then
	echo "ERROR: could not find airport executable"
	exit 1
fi

#Get saved network names
set -f #turn off globbing
IFS='
'		#split and newlines only
saved_wifi_networks=($(networksetup -listpreferredwirelessnetworks en0)) #set array
unset IFS	#unset IFS and reset globbing
set +f

echo "Select a saved network from below: "
for (( i = 1; i < ${#saved_wifi_networks[@]}; i++ )); do #Skip first line of info
	echo -e "[$i] ${saved_wifi_networks[$i]}"
done

#Read in user input
echo
read -p "Enter the number of the interface to retrieve the password (1-$((${#saved_wifi_networks[@]}-1))): " selected_index

#Get SSID from input
ssid=$(echo "${saved_wifi_networks[$selected_index]}" | sed -e 's/^[[:space:]]*//') #ssid with removed preceeding whitespace

#Get password for ssid
password_info="`security find-generic-password -D 'AirPort network password' -ga \"$ssid\" 2>&1 >/dev/null`"

echo -e "\n**Network Credentials**"
echo -e "network : \"$ssid\""
echo -e "$password_info"