# domains-to-ip

# About:
The purpose of this script is to collect  all the subdomains and then filter out those subodmains which are alive and then resolves them into IP. 
Finally will run an advanced level NMAP NSE scan on those IP's.

# Prerequisite:
Make sure go language is installed and setup on correct path.
if not installed, check my bug-bounty-automation repo, i have already given commands there.

# Installation:
1. git clone https://github.com/machine1337/dom-to-ip  .
2. chmod +x install.sh
3. chmod +x script.sh

# Usage:
cat domains.txt | ./script.sh

or

./script.sh domains.txt

# Note:
Q: What should my domains.txt looks like?

     testphp.vulnweb.com
     evil.com
     
# Current Features:
 1. Subdomains Enumeration.
 2. Resolving domains to ip's.
 3. Run advanced level NMAP nse scan.
 
# Special Thanks To:
  @tomnomnom.
  @projectdiscovery
