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
echo -e "\n\e[00;33m#########################################################\e[00m"
echo -e "\e[00;32m#                                                       #\e[00m" 
echo -e "\e[00;31m#\e[00m" "\e[01;32m          DOMAINS TO IP'S RESOLVERS & NMAP NSE SCAN \e[00m" "\e[00;31m#\e[00m"
echo -e "\e[00;34m#                                                       #\e[00m" 
echo -e "\e[00;35m#########################################################\e[00m"
echo -e ""
echo -e "\e[00;36m##### https://www.facebook.com/unknownclay/ #####\e[00m"
echo -e "\e[00;37m#####       Coded By: Machine404            #####\e[00m"

echo -e "\n\e[00;35m#########################################################\e[00m"
d=$(date +"%b-%d-%y %H:%M")
sleep 2
echo -e "\n\e[00;35m#################### Installtion Started On: $d ###########################\e[00m"
sleep 1
echo -e ${BLUE}"[+]\nChecking Go Installation"

if [[ -z "$GOPATH" ]]; then
  echo "............It Looks Like Go is Not Installed.............."
  exit 1
  else
  echo ".............Go is already installed.............."
 fi
echo -e ${GREEN}"[+]\nInstalling Assetfinder"
sleep 1

assetfinder_checking(){
command -v "assetfinder" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then 
        echo "Installing assetfinder: "
        go get -u github.com/tomnomnom/assetfinder >/dev/null 2>&1
        echo ".............assetfinder successfully installed.............."
        else
        echo ".......assetfinder already installed.........."
    fi

}
assetfinder_checking
sleep 1
echo -e ${RED}"[+]\nInstalling Seclists"
command -v "seclists" >/dev/null 2>&1
if [[ ! -d /usr/share/seclists ]]; then 
        sudo apt update
        sudo apt install seclists >/dev/null 2>&1
        echo "....................Seclists Successfully Installed................."
        
        else
        echo ".................Seclists Already Exists................."
fi
      
sleep 1
echo -e ${PINK}"[+]\nInstalling Amass"
amass_checking(){

command -v "amass" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
         echo "Installing amass:"
         sudo apt-get install update
         sudo apt-get install amass
         echo "................Amass successfully installed.............."
         else
         echo "..........Amass is already installed.........."
   fi
}
amass_checking
sleep 1
echo -e ${GRAY}"[+]\nInstalling jq"
jq_checking(){

command -v "jq" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
         echo "Installing jq:"
         sudo apt-get install update
         sudo apt-get install jq
         echo ".................jq successfully installed.............."
         else
         echo "...........jq is already installed.............."
   fi

}
jq_checking

sleep 1
echo -e ${ORANGE}"[+]\nInstalling Subfinder"
subfinder_checking(){
command -v "subfinder" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
         echo "Installing subfinder:"
         GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder
         echo "................subfinder successfully installed.............."
         else
         echo "...........subfinder is already installed............."
   fi

}
subfinder_checking
sleep 1
echo -e ${YELLOW}"[+]\nInstalling massdns"
massdns_checking(){
mkdir -p ~/tools
command -v "massdns" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
         echo "Installing massdns.....\n\n:"
         cd ~/tools
         git clone https://github.com/blechschmidt/massdns.git
         cd massdns
          make
          cd bin
          sudo mv massdns /usr/local/bin
          echo "............massdns installed successfully............"
         else
         echo "..........massdns is already installed............"
    fi

}
massdns_checking
sleep 1
echo -e ${CNC}"[+]\nInstalling dnsvalidator"
dnsvalidator_installing(){
mkdir -p ~/tools
mkdir -p ~/tools/resolvers


command -v "dnsvalidator" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
        cd ~/tools
       git clone  https://github.com/vortexau/dnsvalidator.git
       cd dnsvalidator
       sudo apt-get install python3-pip
       sudo python3 setup.py install
       dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 25 -o resolvers.txt
       cat resolvers.txt | tail -n 60 > ~/tools/resolvers/resolver.txt
       else
        echo ".......dnsvalidator already exist...!\n\n"
fi

}
dnsvalidator_installing
sleep 1

other_tools(){
echo -e ${CPO}"[+]\nInstalling httpx"
command -v "httpx" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
         echo "Installing httpx.....\n\n:"
        go get -v github.com/projectdiscovery/httpx/cmd/httpx
        echo ".................httpx successfully installed.............."
         else
         echo "...............httpx is already installed............."
   fi

sleep 1
echo -e ${CP}"[+]\nInstalling httprobe"
command -v "httprobe" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
         echo "Installing httprobe.....\n\n:"
         go get -u github.com/tomnomnom/httprobe
         echo ".............httprobe successfully installed.............."
         else
         echo "...........httprobe is already installed..............."
   fi
}
other_tools
sleep 1
echo -e ${CG}"[+]\nInstalling NMAP NSE scripts"
nmap_script(){
     if [ -f /usr/share/nmap/scripts/vulners.nse ]; then
           
         echo "...............Script already exists................"
         else
         cd /usr/share/nmap/scripts
         sudo wget https://raw.githubusercontent.com/vulnersCom/nmap-vulners/master/vulners.nse
         echo "...............Scripts successfully installed.................."
         
    fi
sleep 1
echo -e ${CP}"[+] Installing vulnscan For NMAP"
    if [ -d /usr/share/nmap/scripts/vulscan ]; then
               echo "....................vulnscan already exists...................."
        else
        
        cd /usr/share/nmap/scripts
        sudo git clone https://github.com/scipag/vulscan.git
        echo "......................vulnscan successfully installed................"
        
        exit 1
    fi
}
nmap_script
