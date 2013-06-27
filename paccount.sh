#!/bin/bash
# 
# Port Accountant v1.0 - Easily find out what servers are attempting to connect to your service (port).
# David Mcanulty 2013
#
# Requires: tcpdump
mon_port=$1
known_hosts=()

echo "Port Accountant v1.0 David Mcanulty 2013"
echo -e "\t- Prints hosts attempting connections to a port on local system\n"

if [[ ${mon_port} = *[^0-9\-]* ]] || [[ -z "${mon_port}" ]] ;then
   echo "(${mon_port}) is empty or a non-digit value"
   echo "This script requires a port # on the commandline to run accounting on"
   echo "for example: $0 80"
   exit 1
fi

if [[ $(whoami) != "root" ]] ;then
  echo "You must run this script as root (for tcpdump)"
  exit 1
fi

while : ;do
   echo "The following ${#known_hosts[@]} hosts have connected to port $mon_port of ${HOSTNAME} so far:"
   exclude_hosts=""
   for host in ${known_hosts[@]}; do
      if [[ ${#known_hosts[@]} -gt 18 ]] ;then
         echo -ne "\t${host}"
      else
         echo -ne "\t${host}\n"
      fi
      exclude_hosts+=" and not src host ${host}"
   done
   new_host=$(tcpdump -i any -Nq -c1 dst port $mon_port $exclude_hosts 2>/dev/null)
 
   if [[ $? -ne 0 ]] ;then
      echo "Sorry, tcpdump threw errorcode $?"
      exit 1
   fi

   #Strip the hostname (or IP) down to basics
   read -r _ _ new_host _ <<< "$new_host" #grab 3rd column
   new_host="${new_host%\.*}"

   known_hosts+=("$new_host")
   echo -ne "\nFound new host: ${new_host} adding to list of known hosts\n"
done
