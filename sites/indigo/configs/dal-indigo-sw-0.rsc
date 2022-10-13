#
# dal-indigo-sw-0
#

#
# Naming
#

/system/identity/set name="dal-indigo-sw-0"


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

/interface/bridge/add name=CORE vlan-filtering=no


#
# Trunk Ports
#

/interface/bridge/port
add bridge=CORE interface=ether1       pvid=106 comment="front-1 camera"
add bridge=CORE interface=ether2       pvid=106 comment="rear-1 camera"
add bridge=CORE interface=ether3       pvid=106 comment="rear-2 camera"
add bridge=CORE interface=ether4       pvid=106 comment="garage-1 camera"
add bridge=CORE interface=ether5       pvid=105 comment="doorbell"
add bridge=CORE interface=ether6                comment="" 
add bridge=CORE interface=ether7                comment="dal-indigo-wap-0 (upstairs)"
add bridge=CORE interface=ether8                comment="dal-indigo-wap-1 (downstairs)"
add bridge=CORE interface=ether9       pvid=100 comment="master-bedroom-1"
add bridge=CORE interface=ether10      pvid=100 comment="master-bedroom-2" 
add bridge=CORE interface=ether11      pvid=100 comment="left-study-1"
add bridge=CORE interface=ether12      pvid=100 comment="left-study-2"
add bridge=CORE interface=ether13      pvid=100 comment="right-study-1"
add bridge=CORE interface=ether14      pvid=100 comment="right-study-2"
add bridge=CORE interface=ether15               comment=""
add bridge=CORE interface=ether16               comment=""
add bridge=CORE interface=ether17      pvid=100 comment="living-room-1"
add bridge=CORE interface=ether18      pvid=100 comment="living-room-2"
add bridge=CORE interface=ether19      pvid=100 comment="media-room-1"
add bridge=CORE interface=ether20      pvid=100 comment="media-room-2"
add bridge=CORE interface=ether21               comment=""
add bridge=CORE interface=ether22               comment=""
add bridge=CORE interface=ether23               comment=""
add bridge=CORE interface=ether24               comment=""
add bridge=CORE interface=sfp-sfpplus1          comment="dal-indigo-fw-0"
add bridge=CORE interface=sfp-sfpplus2          comment="dal-indigo-sw-1"
add bridge=CORE interface=sfp-sfpplus3          comment=""
add bridge=CORE interface=sfp-sfpplus4          comment=""

/interface/bridge/vlan
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus1,sfp-sfpplus2 untagged=ether9,ether10,ether11,ether12,ether13,ether14,ether17,ether18,ether19,ether20 vlan-ids=100
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus1,sfp-sfpplus2 vlan-ids=101
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus1,sfp-sfpplus2 vlan-ids=102
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus1,sfp-sfpplus2 vlan-ids=103
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus1,sfp-sfpplus2 vlan-ids=104
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus1,sfp-sfpplus2 untagged=ether5 lan-ids=105
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus1,sfp-sfpplus2 untagged=ether1,ether2,ether3,ether4 vlan-ids=106
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus1,sfp-sfpplus2 vlan-ids=107
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus1,sfp-sfpplus2 vlan-ids=108
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus1,sfp-sfpplus2 vlan-ids=109


#
# IP Addressing & Routing
#

# General router settings
/ip/dns/set servers="192.168.79.192"

# Management VLAN
/interface/vlan/add interface=CORE name=MANAGEMENT_VLAN vlan-id=109
/ip/address/add address=192.168.79.193/26 interface=MANAGEMENT_VLAN


#
# Firewall & NAT
#

/interface/list/add name=MANAGEMENT
/interface/list/member/add interface=MANAGEMENT_VLAN list=MANAGEMENT

/ip/firewall/filter

# Input Chain
add chain=input action=accept connection-state=established,related,untracked comment="accept established,related,untracked"
add chain=input action=accept connection-state=invalid comment="drop invalid"
add chain=input action=accept dst-address=127.0.0.1 comment="accept to local loopback (for CAPsMAN)"

# Add more general input related access here
add chain=input action=accept in-interface=MANAGEMENT_VLAN

# Remove the catchall once comfortable
add chain=input action=accept comment="catchall"
add chain=input action=drop comment="drop all other input"


#
# VLAN Security
#

/interface/bridge/port
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=ether7]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=ether8]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus1]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus2]

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
