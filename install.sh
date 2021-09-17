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
echo -e ${RED}    "###############################################################"
echo -e ${ORANGE} " #     DOMAIN'S TO IP RESOLVERS & NMAP NSE SCRIPT SCAN         #  "
echo -e ${PINK}   " #                                                             #  "
echo -e ${BLUE}   " #              https://facebook.com/unknownclay               #  "
echo -e ${YELLOW} " #             Coded By: Machine404                            #  "
echo -e ${CP}     " #             https://github.com/machine1337                  #  "
echo -e ${RED}    "################################################################ \n "
d=$(date +"%b-%d-%y %H:%M")
sleep 1
echo -e ${CP}"[+]Installtion Started On: $d \n"
sleep 1
echo -e ${BLUE}"[+]Checking Go Installation\n"

if [[ -z "$GOPATH" ]]; then
  echo -e ${RED}"[+]Go is not Installed....Plz Install it and run the script again"
  echo -e ${CP}"[+]For Installation Plz Check my recon-automation repo pre-requisite part!"
  exit 1
  else
  echo -e ${BLUE}"..........Go is installed..............\n"
 fi
echo -e ${GREEN}"[+]Installing Assetfinder\n"
sleep 1

assetfinder_checking(){
command -v "assetfinder" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then 
        go get -u github.com/tomnomnom/assetfinder >/dev/null 2>&1
        echo -e ".............assetfinder successfully installed..............\n"
        else
        echo -e ".......assetfinder already installed..........\n"
    fi

}
assetfinder_checking
sleep 1
echo -e ${RED}"[+]Installing Seclists\n"
command -v "seclists" >/dev/null 2>&1
if [[ ! -d /usr/share/seclists ]]; then 
        
        sudo apt install seclists -y
        echo -e "....................Seclists Successfully Installed.................\n"
        
        else
        echo -e ".................Seclists Already Exists.................\n"
fi
      
sleep 1
echo -e ${PINK}"[+]Installing Amass\n"
amass_checking(){

command -v "amass" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
         
         sudo apt-get install amass -y
         echo -e "................Amass successfully installed..............\n"
         else
         echo -e "..........Amass is already installed..........\n"
   fi
}
amass_checking
sleep 1
echo -e ${GRAY}"[+]Installing jq\n"
jq_checking(){

command -v "jq" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
         
         sudo apt-get install jq -y
         echo -e ".................jq successfully installed..............\n"
         else
         echo -e "...........jq is already installed..............\n"
   fi

}
jq_checking

sleep 1
echo -e ${ORANGE}"[+]Installing Subfinder\n"
subfinder_checking(){
command -v "subfinder" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
         
         GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder >/dev/null 2>&1
         echo -e "................subfinder successfully installed..............\n"
         else
         echo -e "...........subfinder is already installed.............\n"
   fi

}
subfinder_checking
sleep 1
echo -e ${YELLOW}"[+]Installing massdns\n"
massdns_checking(){
mkdir -p ~/tools
command -v "massdns" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
         cd ~/tools
         git clone https://github.com/blechschmidt/massdns.git
         cd massdns
          make
          cd bin
          sudo mv massdns /usr/local/bin
          echo -e "............massdns installed successfully............\n"
         else
         echo -e "..........massdns is already installed............\n"
    fi

}
massdns_checking
sleep 1
echo -e ${CNC}"[+]Installing dnsvalidator\n"
dnsvalidator_installing(){
mkdir -p ~/tools
mkdir -p ~/tools/resolvers


command -v "dnsvalidator" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
        cd ~/tools
       git clone  https://github.com/vortexau/dnsvalidator.git
       cd dnsvalidator
       sudo apt-get install python3-pip -y
       sudo python3 setup.py install 
       dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 25 -o resolvers.txt
       cat resolvers.txt | tail -n 60 > ~/tools/resolvers/resolver.txt
       else
        echo -e ".......dnsvalidator already exist.........\n"
fi

}
dnsvalidator_installing
sleep 1

other_tools(){
echo -e ${CPO}"[+]Installing httpx\n"
command -v "httpx" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
         
        go get -v github.com/projectdiscovery/httpx/cmd/httpx >/dev/null 2>&1
        echo -e ".................httpx successfully installed..............\n"
         else
         echo -e "...............httpx is already installed.............\n"
   fi

sleep 1
echo -e ${CP}"[+]Installing httprobe\n"
command -v "httprobe" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
         
         go get -u github.com/tomnomnom/httprobe >/dev/null 2>&1
         echo -e".............httprobe successfully installed..............\n"
         else
         echo -e "...........httprobe is already installed...............\n"
   fi
}
other_tools
sleep 1
echo -e ${CG}"[+]Installing NMAP NSE scripts\n"
nmap_script(){
     if [ -f /usr/share/nmap/scripts/vulners.nse ]; then
           
         echo -e "...............Script already exists................\n"
         else
         cd /usr/share/nmap/scripts
         sudo wget https://raw.githubusercontent.com/vulnersCom/nmap-vulners/master/vulners.nse
         echo -e "...............Scripts successfully installed..................\n"
         
    fi
sleep 1
echo -e ${CP}"[+] Installing vulnscan For NMAP\n"
    if [ -d /usr/share/nmap/scripts/vulscan ]; then
               echo -e "....................vulnscan already exists....................\n"
        else
        
        cd /usr/share/nmap/scripts
        sudo git clone https://github.com/scipag/vulscan.git
        echo -e "......................vulnscan successfully installed................\n"
        
        exit 1
    fi
}
nmap_script
echo -e ${BLUE}"[+] Installation Done :) "
