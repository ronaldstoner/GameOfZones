#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/go/bin:/home/stoner/go/bin:/usr/local/go/bin:/home/stoner/go/bin:/usr/local/go/bin:/home/stoner/go/bin

my_zone="stoner-ibc-1b"
goz_zone="gameofzoneshub-1b"
my_client="yourclientid"
goz_client="gozhubclientid"

printf "\033[32;1m\n\n[+] Stoner's GoZ KeepAlive Script - Phase 1\n[+] Github - ronaldstoner\n\033[0m\n" 

# Main timer loop
(
  while true; do
    now=$(date +"%s")

    last_update=$(gaiacli query ibc client state $goz_client --chain-id $goz_zone --node "http://your_rpc_endpoint:26657" -o json | jq '.' | grep "\"time\"") 

    last_update=$(echo $last_update | cut -d \" -f 4) # Pull out timestamp
    last_update=$(date +"%s" -d "$last_update")
    next_update=`expr $last_update + 1200` 	#1200 seconds = 20 minutes. Set this under trust period.

    #Debug Checks
    #printf "last update - 	$last_update\n";
    #printf "now - 		$now\n";
    #printf "next update - 	$next_update\n";

    if [ $now -gt $next_update ]  
    then 
	    #Refresh lite clients
	    rly lite update $my_zone
	    rly lite update $goz_zone
	    sleep 2;

	    #Local client update - Uncomment if needed 
	    #rly tx raw update-client $my_zone $goz_zone $my_client
	    #sleep 2; 

   	    #Hub Connection Update
	    rly tx raw update-client $goz_zone $my_zone $goz_client
	    printf "\n\033[32;1m[+]\033[0m Sent update $(date +"%T")\n\n";

    else
	    #printf "don't run";
	    dumb_var=1 	# Dumb loop logic, or else error. Didn't feel like wewriting if statement every debug attempt
    fi
	
    sleep 5; #Loop every 5 seconds
  done
)
