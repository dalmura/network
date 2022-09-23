#
# dal-indigo-fw-0
#

#
# Naming
#

/system identity set name="dal-indigo-fw-0"


#
# Network Overview
#

# 100 = GENERAL        = 192.168.76.0/25    = 126
# 101 = GUEST          = 192.168.76.128/26  =  62
# 102 = VPN            = 192.168.76.192/26  =  62
# 103 = SERVERS        = 192.168.77.0/25    = 126
# 104 =                = 192.168.77.128/25  = 126
# 105 = IOT_INTERNET   = 192.168.78.0/25    = 126
# 106 = IOT_RESTRICTED = 192.168.78.128/25  = 126
# 107 =                = 192.168.79.0/25    = 126
# 108 = SERVICES       = 192.168.79.128/26  =  62
# 109 = MANAGEMENT     = 192.168.79.192/26  =  62


#
# Bridge
#

/interface bridge add name=CORE protocol-mode=none vlan-filtering=no


#
# Trunk Ports
#

/interface bridge port

add bridge=CORE interface=ether2
add bridge=CORE interface=ether3
add bridge=CORE interface=ether4
add bridge=CORE interface=ether5
add bridge=CORE interface=ether6
add bridge=CORE interface=ether7
add bridge=CORE interface=ether8
add bridge=CORE interface=sfp-sfpplus1

/interface bridge vlan

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
/ip dns set allow-remote-requests=yes servers="1.1.1.1,8.8.8.8"
/ip dhcp-client add interface=ether1 use-peer-dns=no use-peer-ntp=no add-default-route=yes dhcp-options=""

# General VLAN
/interface vlan add interface=CORE name=GENERAL_VLAN vlan-id=100
/ip address add interface=GENERAL_VLAN address=192.168.76.1/25
/ip pool add name=general-dhcp ranges=192.168.76.10-192.168.76.126
/ip dhcp-server add address-pool=general-dhcp interface=GENERAL_VLAN name=general-dhcp disabled=no
/ip dhcp-server network add address=192.168.76.0/25 dns-server=192.168.76.1 gateway=192.168.76.1

# Guest VLAN
/interface vlan add interface=CORE name=GUEST_VLAN vlan-id=101
/ip address add interface=GUEST_VLAN address=192.168.76.129/26
/ip pool add name=general-dhcp ranges=192.168.76.130-192.168.76.190
/ip dhcp-server add address-pool=guest-dhcp interface=GUEST_VLAN name=guest-dhcp disabled=no
/ip dhcp-server network add address=192.168.76.128/26 dns-server=192.168.76.129 gateway=192.168.76.129

# VPN VLAN
/interface vlan add interface=CORE name=VPN_VLAN vlan-id=102
/ip address add interface=VPN_VLAN address=192.168.76.193/26

# Servers VLAN
/interface vlan add interface=CORE name=SERVERS_VLAN vlan-id=103
/ip address add interface=SERVERS_VLAN address=192.168.77.1/25
/ip pool add name=servers-static ranges=192.168.77.2-192.168.77.63
/ip pool add name=servers-dhcp ranges=192.168.77.64-192.168.76.126
/ip dhcp-server add address-pool=servers-dhcp interface=SERVERS_VLAN name=servers-dhcp disabled=no
/ip dhcp-server network add address=192.168.77.0/25 dns-server=192.168.77.1 gateway=192.168.77.1

# IOT Internet VLAN
/interface vlan add interface=CORE name=IOT_INTERNET_VLAN vlan-id=105
/ip address add interface=IOT_INTERNET_VLAN address=192.168.78.1/25
/ip pool add name=iot-internet-static ranges=192.168.78.2-192.168.76.69
/ip pool add name=iot-internet-dhcp ranges=192.168.78.70-192.168.76.126
/ip dhcp-server add address-pool=iot-internet-dhcp interface=IOT_INTERNET_VLAN name=iot-internet-dhcp disabled=no
/ip dhcp-server network add address=192.168.78.0/25 dns-server=192.168.78.1 gateway=192.168.78.1

# IOT Restricted VLAN
/interface vlan add interface=CORE name=IOT_RESTRICTED_VLAN vlan-id=106
/ip address add interface=IOT_RESTRICTED_VLAN address=192.168.78.129/25
/ip pool add name=iot-internet-static ranges=192.168.78.130-192.168.76.199
/ip pool add name=iot-internet-dhcp ranges=192.168.78.200-192.168.76.254
/ip dhcp-server add address-pool=iot-restricted-dhcp interface=IOT_RESTRICTED_VLAN name=iot-restricted-dhcp disabled=no
/ip dhcp-server network add address=192.168.78.128/25 dns-server=192.168.78.128 gateway=192.168.78.128

# Services VLAN
/interface vlan add interface=CORE name=SERVICES_VLAN vlan-id=108
/ip address add address=192.168.79.129/26 interface=SERVICES_VLAN

# Management VLAN
/interface vlan add interface=CORE name=MANAGEMENT_VLAN vlan-id=109
/ip address add address=192.168.79.193/26 interface=MANAGEMENT_VLAN


#
# Firewall & NAT
#

/interface list add name=WAN
/interface list add name=VLAN
/interface list add name=LAN
/interface list add name=INTERNET_ONLY
/interface list add name=BLACKHOLE
/interface list add name=MANAGEMENT

/interface list member
add interface=ether1              list=WAN
add interface=GENERAL_VLAN        list=VLAN
add interface=GUEST_VLAN          list=VLAN
add interface=VPN_VLAN            list=VLAN
add interface=SERVERS_VLAN        list=VLAN
add interface=IOT_INTERNET_VLAN   list=VLAN
add interface=IOT_RESTRICTED_VLAN list=VLAN
add interface=SERVICES_VLAN       list=VLAN
add interface=MANAGEMENT_VLAN     list=VLAN

add interface=GENERAL_VLAN        list=LAN
add interface=GUEST_VLAN          list=INTERNET_ONLY
add interface=VPN_VLAN            list=LAN
add interface=SERVERS_VLAN        list=LAN
add interface=IOT_INTERNET_VLAN   list=INTERNET_ONLY
add interface=IOT_RESTRICTED_VLAN list=BLACKHOLE
add interface=SERVICES_VLAN       list=LAN
add interface=MANAGEMENT_VLAN     list=LAN

/ip firewall filter


#
# Input Chain
#

add chain=input action=accept connection-state=established,related,untracked comment="accept established,related,untracked"
add chain=input action=accept connection-state=invalid comment="drop invalid"
add chain=input action=accept dst-address=127.0.0.1 comment="accept to local loopback (for CAPsMAN)"

# Add more general input related access here
add chain=input action=accept protocol=icmp in-interface-list=LAN comment="accept ICMP from non-restricted"
add chain=input action=accept protocol=udp dst-port=53 comment="accept DNS"
add chain=input action=accept src-address=0.0.0.0 dst-address=255.255.255.255 protocol=udp src-port=68 dst-port=67 in-interface-list=VLAN comment="allow DHCP broadcasts"
add chain=input action=accept in-interface=MANAGEMENT_VLAN

# Remove the catchall once comfortable
add chain=input action=accept comment="catchall"
add chain=input action=drop comment="drop all other input"


#
# Forward Chain
#

add chain=forward action=fasttrack-connection connection-state=established comment="fasttrack"
add chain=forward action=accept connection-state=established,related,untracked comment="accept established,related,untracked"
add chain=forward action=drop connection-state=invalid comment="drop invalid"
add chain=forward action=drop in-interface-list=WAN connection-state=new connection-nat-state=!dstnat comment="drop all from WAN not DSTNATed"

# Add more general forward related access here
add chain=forward action=accept in-interface-list=LAN out-interface-list=WAN comment="accept LAN to WAN"
add chain=forward action=accept connection-state=new in-interface-list=INTERNET_ONLY out-interface-list=WAN comment="accept INTERNET_ONLY to WAN"

# Remove the catchall once comfortable
add chain=forward action=accept comment="catchall"
add chain=forward action=drop comment="drop all other forward"


#
# NAT
#

/ip firewall nat add chain=srcnat out-interface-list=WAN ipsec-policy=out,none action=masquerade comment="Default masquerade"


#
# VLAN Security
#
/interface bridge port
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

/ip neighbor discovery-settings set discover-interface-list=MANAGEMENT
/tool mac-server mac-winbox set allowed-interface-list=MANAGEMENT
/tool mac-server set allowed-interface-list=MANAGEMENT

#
# Enable VLAN Filtering
#

/interface bridge set CORE vlan-filtering=yes
