#!/bin/bash

# This is a script to ensure that I (Justin) always have access to the public IP:

# dynamic DNS domain name:
DYNDOMAIN='<ENTER_YOUR_DOMAIN>'

# Name of file containing IP to be created if IPs are inconsistent:
IP_FILE='<PATH_TO_REMOTE_FILE>'

# Name of remote file:
RFILE=".$(DYNDOMAIN)-pubip"

#scp command with custom flags:
alias SCP='$(which scp) -P 2022'

# Where to copy file to:
REMOTE_FILE="~/$RFILE"

# create a variable with command to allow us to execute remote commands over ssh:
REMOTE="ssh -p 2022 $DYNDOMAIN"
# get the ip address of $DYNDOMAIN:
#KGUARD_IP='host vaka.kguard.org | egrep '([[:digit:]]{1,3}\.?){1,4}' -o'
KGUARD_IP=`host "$DYNDOMAIN" | egrep -o '([[:digit:]]{1,3}\.){3}([[:digit:]]{1,3})'`

#let's check out what our real public ip is:
CURRENT_PUB_IP=`curl checkip.dyndns.org | cut -f2 -d':' | cut -f1 -d'<'` 

# just in case the above macro does not work:
CURRENT_PUB_IP=${CURRENT_PUB_IP:-`curl ifconfig.me`}

# test if they are consistent:
if [[ $KGUARD_IP != $CURRENT_PUB_IP ]]; then 
	# if IPs don't match, create a file containing known public IP:
	/bin/echo `date -I`: $CURRENT_PUB_IP > $IP_FILE ;
	# Start ssh-agent:
	`which ssh-agent` bash;	
	`which ssh-add`;	
	SCP $IP_FILE $REMOTE_SCP
	
	# Confirm that file was copied..
	
	#  grep the content of the remote file, and assign the output to '$REMOTE_IP': 
	REMOTE_IP='$REMOTE grep $CURRENT_PUB_IP $RFILE'
	# Confirm that remote file contains valid IP address:
	if [[ $REMOTE_IP == $CURRENT_PUB_IP ]];
	then
		`which logger` -p news.alert 'Public IP address manually updated as a result of ddclient failing!';
	fi;
fi
	

