#!/bin/bash
# 
# Port Accountant v1.4 - Easily find out what servers are attempting to connect to your service (port).
# David Mcanulty 2013
# last update 2025
#
# Requires: tcpdump
mon_port=$1
dest_host=$2
known_hosts=()
start_time="$(date)"
echo "Port Accountant v1.4 David Mcanulty 2013-2025"
echo -e "\t- Prints hosts attempting connections to a port on local system\n"

if ! [[ ${mon_port} =~ ^[0-9]+$ ]] || [[ -z "${mon_port}" ]] ;then
   echo "Usage: $0 PORT# [optional destination host]"
   exit 1
fi

if [[ -n "${dest_host}" ]] ;then
   dest_filter="and dst host ${dest_host}"
fi

if [[ $(whoami) != "root" ]] ;then
  echo "You must run this script as root (for tcpdump)"
  exit 1
fi

if ! command -v tcpdump >/dev/null ;then
   echo "tcpdump is not installed, or missing from your path, please install"
fi

while : ;do
   term_columns=$(tput cols)
   term_columns=$((term_columns / 38))
   term_lines=$(tput lines)
   term_lines=$((term_lines-2))
   echo "The following ${#known_hosts[@]} hosts have connected to port $mon_port of ${HOSTNAME} since ${start_time}"
   exclude_hosts=""
   for host in "${known_hosts[@]}"; do
      if [[ ${#known_hosts[@]} -gt ${term_lines} ]] ;then
         column_display=1
      else
         column_display=0
      fi
      pretty_host=$(getent hosts "${host}")
      gotdns=$?
      read -r _ pretty_host _ <<< "$pretty_host" #grab 2nd column
      if [[ $gotdns -eq 0 ]] ;then
         if ! [[ ${column_display} == 1 ]] ;then 
            pretty_host="${pretty_host}(${host})"  #hostname lookup worked
         fi
      else
         pretty_host="${host}"  #hostname lookup failed, just use ip
      fi
      if [[ ${column_display} == 1 ]] ;then
         if [[ $current_column -le $term_columns ]] ;then
            ((current_column++))
            printf '%32s' "${pretty_host}"
         else
            current_column=1
            printf '%32s\n' "${pretty_host}"
         fi
      else
         echo -ne "\t${pretty_host}\n"
      fi
      exclude_hosts+=" and not src host ${host}"
   done
   current_column=1
   new_host=$(tcpdump -i any -nq -c1 dst port "$mon_port" "$dest_filter" "$exclude_hosts" 2>/dev/null)
 
   if [[ $? -ne 0 ]] ;then
      echo "Sorry, tcpdump threw errorcode $?"
      exit 1
   fi

   #Strip the hostname (or IP) down to basics
   read -r _ _ old_style_host _ new_style_host _ <<< "$new_host" #grab 3rd column
   # Handle newer tcpdump output
   echo "old_style_host is :${old_style_host}:"
   echo "new_style_host is :${new_style_host}:"
   new_host="$old_style_host"
   if [[ $old_style_host == "In" ]];then
       new_host="$new_style_host"
   fi
   new_host="${new_host%\.*}"

   known_hosts+=("$new_host")
   echo -ne "\nFound new host: ${new_host} adding to list of known hosts at $(date)\n"
done
