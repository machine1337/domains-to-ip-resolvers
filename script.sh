#!/bin/bash
function nmap_scan(){
echo -e "\n\e[00;33m#########################################################\e[00m"
echo -e "\e[00;32m#                                                       #\e[00m" 
echo -e "\e[00;31m#\e[00m" "\e[01;32m     DOMAINS TO IP RESOLVERS & NMAP NSE SCAN \e[00m" "\e[00;31m#\e[00m"
echo -e "\e[00;34m#                                                       #\e[00m" 
echo -e "\e[00;35m#########################################################\e[00m"
echo -e ""
echo -e "\e[00;36m##### https://www.facebook.com/unknownclay/ #####\e[00m"
echo -e "\e[00;37m#####       Coded By: Machine404            #####\e[00m"

echo -e "\n\e[00;35m#########################################################\e[00m"
}
d=$(date +"%b-%d-%y %H:%M")
function scan_single(){
clear
nmap_scan
echo -n "[+] Enter Single domain : " 
           read domain
mkdir -p $domain $domain/masscan $domain/nmap
echo "$domain" > $domain/domain.txt
echo -e "\n\e[00;31m##################Resolving Domain to IP ###########################\e[00m"
massdns -r ~/tools/resolvers/resolver.txt -t A -o S -w $domain/masscan/results.txt $domain/domain.txt
cat $domain/masscan/results.txt | sed '/\/ /g' | awk '{print $3}' | tee $domain/masscan/ip.txt
echo -e "\n\e[00;37m##################Starting NMAP NSE Scan ###########################\e[00m"
nmap -sV  --script vulners.nse -iL $domain/masscan/ip.txt  -oN $domain/nmap/scan.txt
}
function scan_all(){
clear
nmap_scan
echo -n "[+] Enter domain name : "
read domain
mkdir -p $domain $domain/domain_enum $domain/final_domains  $domain/nmap  $domain/masscan 

echo -e "\n\e[00;33m#################### Domain Enumeration Started On: $d ###########################\e[00m"
echo -e "\n\e[00;36m#################### crt.sh Enumeration Started ###########################\e[00m"
curl -s https://crt.sh/\?q\=%25.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | tee $domain/domain_enum/crt.txt
echo -e "\n\e[00;32m#################### subfinder Enumeration Started ###########################\e[00m"
subfinder -d $domain -o $domain/domain_enum/subfinder.txt

echo -e "\n\e[00;33m#################### assetfinder Enumeration Started ###########################\e[00m"
assetfinder -subs-only $domain | tee $domain/domain_enum/assetfinder.txt

echo -e "\n\e[00;34m#################### Amass Enumeration Started ###########################\e[00m"
amass enum -passive -d $domain -o $domain/domain_enum/amass.txt

echo -e "\n\e[00;35m#################### shuffledns  Started ###########################\e[00m"

shuffledns -d $domain -w /usr/share/seclists/Discovery/DNS/deepmagic.com-prefixes-top50000.txt -r ~/tools/resolvers/resolver.txt -o $domain/domain_enum/shuffledns.txt
echo -e "\n\e[00;36m##################Collecting all subdomains into one file ###########################\e[00m"
cat $domain/domain_enum/*.txt > $domain/domain_enum/all.txt

echo -e "\n\e[00;37m##################Resolving All Subdomains ###########################\e[00m"

shuffledns -d $domain -list $domain/domain_enum/all.txt -o $domain/domains.txt -r ~/tools/resolvers/resolver.txt

echo -e "\n\e[00;30m##################Checking Services on subdomains ###########################\e[00m"
cat $domain/domains.txt | httpx -threads 30 -o $domain/final_domains/httpx.txt

echo -e "\n\e[00;31m##################Resolving Domains to IP ###########################\e[00m"
massdns -r ~/tools/resolvers/resolver.txt -t A -o S -w $domain/masscan/results.txt $domain/domains.txt
cat $domain/masscan/results.txt | sed '/\/ /g' | awk '{print $3}' | tee $domain/masscan/ip.txt

echo -e "\n\e[00;37m##################Starting NMAP NSE Scan ###########################\e[00m"

nmap -sV  --script vulners.nse -iL $domain/masscan/ip.txt -oN $domain/nmap/scan.txt



}
function scan_list(){
clear
nmap_scan
echo -n "[+] Enter path of  domains list: "
read host
for domain in $(cat $host);
do
mkdir -p $domain $domain/masscan $domain/nmap
echo "$domain" > $domain/domain.txt
echo -e "\n\e[00;31m##################Resolving Domains to IP ###########################\e[00m"
massdns -r ~/tools/resolvers/resolver.txt -t A -o S -w $domain/masscan/results.txt $domain/domain.txt
cat $domain/masscan/results.txt | sed '/\/ /g' | awk '{print $3}' | tee $domain/masscan/ip.txt

echo -e "\n\e[00;37m##################Starting NMAP NSE Scan ###########################\e[00m"

nmap -sV  --script vulners.nse -iL $domain/masscan/ip.txt  -oN $domain/nmap/scan.txt

done

}

menu(){
clear
nmap_scan
echo -e "\n[*] Which Type of Scan u want to Perform\n "
echo -e "[1] Single domain Scan\n[2] List of domains\n[3] Full domain scan with subdomains"
echo -n "[+] Select: "
        read js_play
                if [ $js_play -eq 1 ]; then
                        scan_single
                elif [ $js_play -eq 2 ]; then
                        scan_list
                elif [ $js_play -eq 3 ]; then
                        scan_all
                fi

}
menu
