#!/bin/bash

function main(){

    echo -e "\n*** DHCP Server Configuration ***\n"

    which dhcpd &> /dev/null
    if [ "$?" != "0" ];then
        echo -e "DHCP Not Found!\n"
        sleep 1s
        echi "Wait, while we install the service for you."
        apt install isc-dhcp-server -y &> /dev/null
        echo "DHCP Service has been added."
    else
        echo "DHCP Exists, we will move on to Installation."
    fi

    sleep 2s
    read -p "Enter Domain name : " od


    echo -e "option domain-name \"$od\";" > /etc/dhcp/dhcpd.conf
    echo -e "\ndefault-lease-time 3600; \nmax-lease-time 7200; \nauthoritative;" >> /etc/dhcp/dhcpd.conf
    echo -e "\nddns-update-style none;" >> /etc/dhcp/dhcpd.conf


    ip=$(ifconfig ens33 | grep "inet " | awk -F" " '{print ""$2}')
    netmask=$(ifconfig ens33 | grep "inet " | awk -F" " '{print ""$4}')

    read -p "Enter Subnet : " sub
    read -p "Enter Option Routers : " option_r
    read -p "IP Pool starting from : " ip_start
    read -p "IP Pool ending at : " ip_end

    echo -e "\nsubnet $sub netmask $netmask { \noption routers	$option_r; \noption subnet-mask		$netmask; \noption domain-search	\"$od\";\noption domain-name-servers	$option_r; \nrange $ip_start $ip_end; \n}" >> /etc/dhcp/dhcpd.conf

    echo -e "\n\nInput has been registered"
    
    systemctl restart isc-dhcp-server &> /dev/null
    systemctl enable isc-dhcp-server &> /dev/null

    echo -e "\n $start $enable DHCP has been started and has been enabled successfully !!!"

    chk_ip

}

function chk_ip(){

    while true ;
    do
            read -p "Would like to check IP allocation (y/n) : " ch

            case "$ch" in
                    "y" | "Y")
                            #echo -e "You have selected Yes"
                            lease=$(cat /var/lib/dhcp/dhcpd.leases | grep -iE "lease" | tail -1 | awk -F" " '{print ""$2}')
                            echo -e "\n $lease has been assigned"
                            exit 0
                            ;;

                    "n" | "N")
                            exit 0
                            ;;

                    *)
                            echo -e "Invalid input please select (y/n)"
                            ;;
            esac
    done

}

main
