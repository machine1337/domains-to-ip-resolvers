#!/bin/bash
NC='\033[0m'
RED='\033[1;38;5;196m'
GREEN='\033[1;38;5;040m'
ORANGE='\033[1;38;5;202m'
BLUE='\033[1;38;5;012m'
BLUE2='\033[1;38;5;032m'
PINK='\033[1;38;5;013m'
GRAY='\033[1;38;5;004m'
NEW='\033[1;38;5;154m'
YELLOW='\033[1;38;5;214m'
CG='\033[1;38;5;087m'
CP='\033[1;38;5;221m'
CPO='\033[1;38;5;205m'
CN='\033[1;38;5;247m'
CNC='\033[1;38;5;051m'

function nmap_scan(){
echo -e ${CPO}"#########################################################"                                                  
echo -e ${RED}"#      Domains To IP Resolvers & NMAP NSE SCAN          #"
echo -e ${BLUE}"#        A FrameWork For Advanced NMAP SCAN             #"
echo -e ${CG}"#          https://facebook.com/unknownclay             #"
echo -e ${CP}"#          Coded By:  Machine1337	                #"
echo -e ${CP}"#          https://github.com/machine1337               #  "
echo -e ${CPO}"########################################################"

}
d=$(date +"%b-%d-%y %H:%M")
function scan_single(){
clear
nmap_scan
echo -n -e ${RED}"\n[+] Enter Single domain : " 
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
echo -e -n ${ORANGE}"\n[+] Enter domain name : "
read domain
mkdir -p $domain $domain/domain_enum $domain/final_domains  $domain/nmap  $domain/masscan 

echo -e "\n\e[00;33m#################### Domain Enumeration Started On: $d ####################\e[00m"
sleep 1
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
echo -e "\n\e[00;36m##################Collecting all subdomains into one file #######################\e[00m"
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
echo -n -e ${BLUE2}"\n[+] Enter path of  domains list: "
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
echo -e ${YELLOW}"\n[*] Which Type of Scan u want to Perform\n "
echo -e "  ${NC}[${CG}"1"${NC}]${CNC} Single domain Scan"
echo -e "  ${NC}[${CG}"2"${NC}]${CNC} List of domains"
echo -e "  ${NC}[${CG}"3"${NC}]${CNC} Full domain scan with subdomains"
echo -e "  ${NC}[${CG}"4"${NC}]${CNC} Exit"

echo -n -e ${YELLOW}"\n[+] Select: "
        read js_play
                if [ $js_play -eq 1 ]; then
                        scan_single
                elif [ $js_play -eq 2 ]; then
                        scan_list
                elif [ $js_play -eq 3 ]; then
                        scan_all
                elif [ $js_play -eq 4 ]; then
                      exit
                fi

}
menu
