#!/bin/bash                                                                                                                                                                                                                                                        
cat NMAP_all_hosts.txt | egrep '([0-9]){1,5}[\/](tcp|udp)' | awk -F ' ' '{ print $NF }' | sort -u > services.txt #cats out the main file the runs the file and takes all the services listed, rids duplicates and adds them all to a list
cat NMAP_all_hosts.txt | egrep -e '([0-9]{1,3}[.]){3}[0-9]{1,3}$' -e '([0-9]){1,5}[\/](tcp|udp)' | awk -F ' ' '{ print $NF }' > nmap_refined.txt #cats out main nmap file and takes all ips and their services the used                                                                                                                                                                                                   
IP_REGEX='([0-9]{1,3}[.]){3}[0-9]{1,3}$' #sets the var equal to the regex of an ip                                                                                                                                                     
while read service; do                                                                                                                                                                        
        counter=0 #(re)sets the counter to 0                                                                                                                                                  
        iplist=() #(re)sets the array to empty array                                                                                                                                          
        while read nmap_line; do #reads each line in nmap_refined and sees if it is an ip and then  takes ip from line if it is an ip                                                         
                if [[ $nmap_line =~ $IP_REGEX ]]; then daip=$(echo $nmap_line | egrep '([0-9]{1,3}[.]){3}[0-9]{1,3}$'); fi #assigns ip to var to be added to array later                      
                if [[ $nmap_line = $service ]]; then iplist+=("${daip}"); fi #checks if the line in the nmap_refined is a service and if so adds to the sevices counter 2(adds the ip to that service)
        done<nmap_refined.txt                                                                                                                                                                 
        sorted_ips=($(echo "${iplist[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')) #gets rid of dup ips                                                                                                                                                                                                                                                     
        for i in "${sorted_ips[@]}"; do let counter++; done #for loop for ip count, post sort                                                                
        echo -e "Service: $service Count: $counter\n=================================" #print lines to get the information and format need for the answers                                                                                                        
        (IFS=$'\n'; echo -e "${sorted_ips[*]} \n")                                                                                                                                            
done <services.txt 
