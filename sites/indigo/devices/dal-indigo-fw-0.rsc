#
# dal-indigo-fw-0
#

#
# Naming
#

/system/identity/set name="dal-indigo-fw-0"


#
# Network Overview
#

# 100 = GENERAL         = 192.168.76.0/25    = 126
# 101 = GUEST           = 192.168.76.128/26  =  62
# 102 = VPN             = 192.168.76.192/26  =  62
# 103 = SERVERS         = 192.168.77.0/25    = 126
# 104 = SERVERS_STAGING = 192.168.77.128/25  = 126
# 105 = IOT_INTERNET    = 192.168.78.0/25    = 126
# 106 = IOT_RESTRICTED  = 192.168.78.128/25  = 126
# 107 =                 = 192.168.79.0/25    = 126
# 108 = SERVICES        = 192.168.79.128/26  =  62
# 109 = MANAGEMENT      = 192.168.79.192/26  =  62


#
# Bridge
#

/interface/bridge/add name=CORE vlan-filtering=no


#
# Trunk Ports
#

/interface/bridge/port
add bridge=CORE interface=ether2       comment=""
add bridge=CORE interface=ether3       comment=""
add bridge=CORE interface=ether4       comment=""
add bridge=CORE interface=ether5       comment=""
add bridge=CORE interface=ether6       comment=""
add bridge=CORE interface=ether7       comment=""
add bridge=CORE interface=ether8       comment=""
add bridge=CORE interface=sfp-sfpplus1 comment="dal-indigo-sw-0"

/interface/bridge/vlan
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,sfp-sfpplus1 vlan-ids=100
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,sfp-sfpplus1 vlan-ids=101
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,sfp-sfpplus1 vlan-ids=102
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,sfp-sfpplus1 vlan-ids=103
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,sfp-sfpplus1 vlan-ids=104
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,sfp-sfpplus1 vlan-ids=105
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,sfp-sfpplus1 vlan-ids=106
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,sfp-sfpplus1 vlan-ids=107
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,sfp-sfpplus1 vlan-ids=108
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,sfp-sfpplus1 vlan-ids=109


#
# IP Addressing & Routing
#

# General router settings
/certificate
add name=ca days-valid=10950 common-name=dal-indigo-fw-0.indigo.dalmura.au key-usage=key-cert-sign,crl-sign
add name=server days-valid=10950 common-name=dal-indigo-fw-0.indigo.dalmura.au

sign ca name=root-ca
:delay 2
sign ca=root-ca server name=server
:delay 2

set root-ca trusted=yes
set server trusted=yes

/ip/dns/set allow-remote-requests=yes servers="1.1.1.1,8.8.8.8"
/ip/cloud/set ddns-enabled=yes ddns-update-interval=15m update-time=yes
/ip/service/set www-ssl tls-version=only-1.2 address=192.168.79.192/26 certificate=server disabled=no

# WAN settings
/ip/dhcp-client/add interface=ether1 use-peer-dns=no use-peer-ntp=no add-default-route=yes dhcp-options=""

# General VLAN
/interface/vlan/add interface=CORE name=GENERAL_VLAN vlan-id=100
/ip/address/add interface=GENERAL_VLAN address=192.168.76.1/25
/ip/pool/add name=general-dhcp ranges=192.168.76.10-192.168.76.126
/ip/dhcp-server/add address-pool=general-dhcp interface=GENERAL_VLAN name=general-dhcp disabled=no
/ip/dhcp-server/network/add address=192.168.76.0/25 dns-server=192.168.76.1 gateway=192.168.76.1 comment="GENERAL_VLAN"

# Guest VLAN
/interface/vlan/add interface=CORE name=GUEST_VLAN vlan-id=101
/ip/address/add interface=GUEST_VLAN address=192.168.76.129/26
/ip/pool/add name=guest-dhcp ranges=192.168.76.130-192.168.76.190
/ip/dhcp-server/add address-pool=guest-dhcp interface=GUEST_VLAN name=guest-dhcp disabled=no
/ip/dhcp-server/network/add address=192.168.76.128/26 dns-server=192.168.76.129 gateway=192.168.76.129 comment="GUEST_VLAN"

# VPN VLAN
/interface/vlan/add interface=CORE name=VPN_VLAN vlan-id=102
/ip/address/add interface=VPN_VLAN address=192.168.76.193/26

# Servers VLAN
/interface/vlan/add interface=CORE name=SERVERS_VLAN vlan-id=103
/ip/address/add interface=SERVERS_VLAN address=192.168.77.1/25
/ip/pool/add name=servers-static ranges=192.168.77.2-192.168.77.63
/ip/pool/add name=servers-dhcp ranges=192.168.77.64-192.168.77.126
/ip/dhcp-server/add address-pool=servers-dhcp interface=SERVERS_VLAN name=servers-dhcp disabled=no
/ip/dhcp-server/network/add address=192.168.77.0/25 dns-server=192.168.77.1 gateway=192.168.77.1 comment="SERVERS_VLAN"

# Servers Staging VLAN
/interface/vlan/add interface=CORE name=SERVERS_STAGING_VLAN vlan-id=104
/ip/address/add interface=SERVERS_STAGING_VLAN address=192.168.77.129/25
/ip/pool/add name=servers-staging-static ranges=192.168.77.129-192.168.77.149
/ip/pool/add name=servers-staging-dhcp ranges=192.168.77.150-192.168.77.254
/ip/dhcp-server/add address-pool=servers-staging-dhcp interface=SERVERS_STAGING_VLAN name=servers-staging-dhcp disabled=no
/ip/dhcp-server/network/add address=192.168.77.128/25 dns-server=192.168.77.129 gateway=192.168.77.129 comment="SERVERS_STAGING_VLAN"

# IOT Internet VLAN
/interface/vlan/add interface=CORE name=IOT_INTERNET_VLAN vlan-id=105
/ip/address/add interface=IOT_INTERNET_VLAN address=192.168.78.1/25
/ip/pool/add name=iot-internet-static ranges=192.168.78.2-192.168.78.69
/ip/pool/add name=iot-internet-dhcp ranges=192.168.78.70-192.168.78.126
/ip/dhcp-server/add address-pool=iot-internet-dhcp interface=IOT_INTERNET_VLAN name=iot-internet-dhcp disabled=no
/ip/dhcp-server/network/add address=192.168.78.0/25 dns-server=192.168.78.1 gateway=192.168.78.1 comment="IOT_INTERNET_VLAN"

# IOT Restricted VLAN
/interface/vlan/add interface=CORE name=IOT_RESTRICTED_VLAN vlan-id=106
/ip/address/add interface=IOT_RESTRICTED_VLAN address=192.168.78.129/25
/ip/pool/add name=iot-restricted-static ranges=192.168.78.130-192.168.78.199
/ip/pool/add name=iot-restricted-dhcp ranges=192.168.78.200-192.168.78.254
/ip/dhcp-server/add address-pool=iot-restricted-dhcp interface=IOT_RESTRICTED_VLAN name=iot-restricted-dhcp disabled=no
/ip/dhcp-server/network/add address=192.168.78.128/25 dns-server=192.168.78.128 gateway=192.168.78.128 comment="IOT_RESTRICTED_VLAN"

# Services VLAN
/interface/vlan/add interface=CORE name=SERVICES_VLAN vlan-id=108
/ip/address/add address=192.168.79.129/26 interface=SERVICES_VLAN

# Management VLAN
/interface/vlan/add interface=CORE name=MANAGEMENT_VLAN vlan-id=109
/ip/address/add address=192.168.79.193/26 interface=MANAGEMENT_VLAN
/ip/pool/add name=management-dhcp ranges=192.168.79.250-192.168.79.254
/ip/dhcp-server/add address-pool=management-dhcp interface=MANAGEMENT_VLAN name=management-dhcp disabled=no
/ip/dhcp-server/network/add address=192.168.79.192/26 dns-server=192.168.79.193 gateway=192.168.79.193 comment="MANAGEMENT_VLAN"


#
# Firewall & NAT
#

/interface/list
add name=WAN
add name=VLAN
add name=LAN
add name=INTERNET_ONLY
add name=BLACKHOLE
add name=MANAGEMENT

/interface/list/member
add interface=ether1               list=WAN
add interface=GENERAL_VLAN         list=VLAN
add interface=GUEST_VLAN           list=VLAN
add interface=VPN_VLAN             list=VLAN
add interface=SERVERS_VLAN         list=VLAN
add interface=SERVERS_STAGING_VLAN list=VLAN
add interface=IOT_INTERNET_VLAN    list=VLAN
add interface=IOT_RESTRICTED_VLAN  list=VLAN
add interface=SERVICES_VLAN        list=VLAN
add interface=MANAGEMENT_VLAN      list=VLAN

add interface=GENERAL_VLAN         list=LAN
add interface=GUEST_VLAN           list=INTERNET_ONLY
add interface=VPN_VLAN             list=LAN
add interface=SERVERS_VLAN         list=LAN
add interface=SERVERS_STAGING_VLAN list=INTERNET_ONLY
add interface=IOT_INTERNET_VLAN    list=INTERNET_ONLY
add interface=IOT_RESTRICTED_VLAN  list=BLACKHOLE
add interface=SERVICES_VLAN        list=LAN
add interface=MANAGEMENT_VLAN      list=LAN
add interface=MANAGEMENT_VLAN      list=MANAGEMENT

/ip/firewall/filter

# Input Chain
add chain=input action=accept connection-state=established,related,untracked comment="accept established,related,untracked"
add chain=input action=drop connection-state=invalid comment="drop invalid"
add chain=input action=accept dst-address=127.0.0.1 comment="accept to local loopback (for CAPsMAN)"

# Add more general input related access here
add chain=input action=accept protocol=icmp in-interface-list=LAN comment="accept ICMP from non-restricted"
add chain=input action=accept protocol=udp dst-port=53 in-interface-list=VLAN comment="accept DNS from internal networks"
add chain=input action=accept src-address=0.0.0.0 dst-address=255.255.255.255 protocol=udp src-port=68 dst-port=67 in-interface-list=VLAN comment="allow DHCP broadcasts"
add chain=input action=accept in-interface=MANAGEMENT_VLAN comment="allow MANAGEMENT_VLAN access"

# Finally drop everything else
add chain=input action=accept log=yes log-prefix=input-catch comment="catchall" disabled=yes
add chain=input action=drop log=yes log-prefix=input-drop comment="drop all other input"

# Forward Chain
add chain=forward action=fasttrack-connection connection-state=established comment="fasttrack"
add chain=forward action=accept connection-state=established,related,untracked comment="accept established,related,untracked"
add chain=forward action=drop connection-state=invalid comment="drop invalid"
add chain=forward action=drop in-interface-list=WAN connection-state=new connection-nat-state=!dstnat comment="drop all from WAN not DSTNATed"

# Add more general forward related access here

## Allow internet access
add chain=forward action=accept in-interface-list=LAN out-interface-list=WAN comment="accept LAN to WAN"
add chain=forward action=accept connection-state=new in-interface-list=INTERNET_ONLY out-interface-list=WAN comment="accept INTERNET_ONLY to WAN"

## Allow MANAGEMENT_VLAN => SERVERS_VLAN
add chain=forward action=accept in-interface=MANAGEMENT_VLAN out-interface=SERVERS_VLAN comment="accept MANAGEMENT_VLAN => SERVERS_VLAN"
## Allow MANAGEMENT_VLAN => SERVERS_STAGING_VLAN
add chain=forward action=accept in-interface=MANAGEMENT_VLAN out-interface=SERVERS_STAGING_VLAN comment="accept MANAGEMENT_VLAN => SERVERS_STAGING_VLAN"

# Finally drop everything else
add chain=forward action=accept log=yes log-prefix=forward-catch comment="catchall" disabled=yes
add chain=forward action=drop log=yes log-prefix=forward-drop comment="drop all other forward"


#
# NAT
#

/ip/firewall/nat/add chain=srcnat out-interface-list=WAN ipsec-policy=out,none action=masquerade comment="Default masquerade"


#
# VLAN Security
#

/interface/bridge/port
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=ether2]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=ether3]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=ether4]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=ether5]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=ether6]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=ether7]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus1]


#
# MAC Server
#

/ip/neighbor/discovery-settings/set discover-interface-list=MANAGEMENT
/tool/mac-server/mac-winbox/set allowed-interface-list=MANAGEMENT
/tool/mac-server/set allowed-interface-list=MANAGEMENT


#
# Enable VLAN Filtering
#

/interface/bridge/set CORE vlan-filtering=yes
