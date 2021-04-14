#!/bin/bash

echo -e "\n\e[00;33m#########################################################\e[00m"
echo -e "\e[00;32m#                                                       #\e[00m" 
echo -e "\e[00;31m#\e[00m" "\e[01;32m         DOMAINS TO IP RESOLVERS & NMAP NSE SCAN \e[00m" "\e[00;31m#\e[00m"
echo -e "\e[00;34m#                                                       #\e[00m" 
echo -e "\e[00;35m#########################################################\e[00m"
echo -e ""
echo -e "\e[00;36m##### https://www.facebook.com/unknownclay/ #####\e[00m"
echo -e "\e[00;37m#####       Coded By: Machine404            #####\e[00m"

echo -e "\n\e[00;35m#########################################################\e[00m"
sleep 2
d=$(date +"%b-%d-%y %H:%M")
host=$1
for domain in $(cat $host);
do
mkdir -p $domain $domain/domain_enum $domain/final_domains  $domain/nmap  $domain/masscan 

echo -e "\n\e[00;33m#################### Domain Enumeration Started On: $d ###########################\e[00m"
sleep 2
domain_recon(){
echo -e "\n\e[00;36m#################### crt.sh Enumeration Started ###########################\e[00m"
curl -s https://crt.sh/\?q\=%25.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | tee $domain/domain_enum/crt.txt
sleep 2
echo -e "\n\e[00;32m#################### subfinder Enumeration Started ###########################\e[00m"
subfinder -d $domain -o $domain/domain_enum/subfinder.txt
sleep 2
echo -e "\n\e[00;33m#################### assetfinder Enumeration Started ###########################\e[00m"
assetfinder -subs-only $domain | tee $domain/domain_enum/assetfinder.txt
sleep 2
echo -e "\n\e[00;34m#################### Amass Enumeration Started ###########################\e[00m"
amass enum -passive -d $domain -o $domain/domain_enum/amass.txt
sleep 2
echo -e "\n\e[00;35m#################### shuffledns  Started ###########################\e[00m"

shuffledns -d $domain -w /usr/share/wordlists/seclists/Discovery/DNS/deepmagic.com-prefixes-top50000.txt -r ~/tools/resolvers/resolver.txt -o $domain/domain_enum/shuffledns.txt
 

sleep 2
echo -e "\n\e[00;36m##################Collecting all subdomains into one file ###########################\e[00m"
cat $domain/domain_enum/*.txt > $domain/domain_enum/all.txt
}
domain_recon
sleep 2
echo -e "\n\e[00;37m##################Resolving All Subdomains ###########################\e[00m"

resolving_domains(){
shuffledns -d $domain -list $domain/domain_enum/all.txt -o $domain/domains.txt -r ~/tools/resolvers/resolver.txt
}
resolving_domains
sleep 2
echo -e "\n\e[00;30m##################Checking Services on subdomains ###########################\e[00m"
http_prob(){
cat $domain/domains.txt | httpx -threads 30 -o $domain/final_domains/httpx.txt
}
http_prob
sleep 2
echo -e "\n\e[00;31m##################Resolving Domains to IP ###########################\e[00m"
get_ip(){
massdns -r ~/tools/resolvers/resolver.txt -t A -o S -w $domain/masscan/results.txt $domain/domains.txt
cat $domain/masscan/results.txt | sed '/\/ /g' | awk '{print $3}' | tee $domain/masscan/ip.txt
}
get_ip
sleep 2
echo -e "\n\e[00;37m##################Starting NMAP NSE Scan ###########################\e[00m"
nmap_scan(){

nmap -sV  --script vulners.nse -iL $domain/masscan/ip.txt -oN $domain/nmap/scan.txt
}
nmap_scan
done
