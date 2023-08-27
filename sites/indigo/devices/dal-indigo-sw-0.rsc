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

# untagged - IOT_RESTRICTED
add bridge=CORE interface=ether1       pvid=106 comment="front-1 camera"

# untagged - IOT_RESTRICTED
add bridge=CORE interface=ether2       pvid=106 comment="rear-1 camera"

# untagged - IOT_RESTRICTED
add bridge=CORE interface=ether3       pvid=106 comment="rear-2 camera"

# untagged - IOT_RESTRICTED
add bridge=CORE interface=ether4       pvid=106 comment="garage-1 camera"

# untagged - IOT_INTERNET
add bridge=CORE interface=ether5       pvid=105 comment="doorbell"

# N/A
add bridge=CORE interface=ether6                comment=""

# trunk
add bridge=CORE interface=ether7                comment="dal-indigo-wap-0 (upstairs)"

# trunk
add bridge=CORE interface=ether8                comment="dal-indigo-wap-1 (downstairs)"

# untagged - GENERAL
add bridge=CORE interface=ether9       pvid=100 comment="master-bedroom-1"

# untagged - GENERAL
add bridge=CORE interface=ether10      pvid=100 comment="master-bedroom-2"

# untagged - GENERAL
add bridge=CORE interface=ether11      pvid=100 comment="left-study-1"

# untagged - GENERAL
add bridge=CORE interface=ether12      pvid=100 comment="left-study-2"

# untagged - GENERAL
add bridge=CORE interface=ether13      pvid=100 comment="right-study-1"

# untagged - GENERAL
add bridge=CORE interface=ether14      pvid=100 comment="right-study-2"

# untagged - GENERAL
add bridge=CORE interface=ether15      pvid=100 comment="living-room-1"

# untagged - GENERAL
add bridge=CORE interface=ether16      pvid=100 comment="living-room-2"

# untagged - GENERAL
add bridge=CORE interface=ether17      pvid=100 comment="media-room-1"

# untagged - GENERAL
add bridge=CORE interface=ether18      pvid=100 comment="media-room-2"

# untagged - SERVERS
add bridge=CORE interface=ether19      pvid=103 comment="laptop-servers"

# untagged - SERVERS_STAGING
add bridge=CORE interface=ether20      pvid=104 comment="laptop-servers-staging"

# hybrid   - SERVERS_STAGING
add bridge=CORE interface=ether21      pvid=104 comment="rpi-hybrid"

# hybrid   - SERVERS_STAGING
add bridge=CORE interface=ether22      pvid=104 comment="rpi-hybrid"

# hybrid   - SERVERS_STAGING
add bridge=CORE interface=ether23      pvid=104 comment="rpi-hybrid"

# hybrid   - SERVERS_STAGING
add bridge=CORE interface=ether24      pvid=104 comment="rpi-hybrid"

# untagged - SERVERS
add bridge=CORE interface=sfp-sfpplus1 pvid=103 comment="dal-indigo-atlas"

# trunk
add bridge=CORE interface=sfp-sfpplus2          comment="dal-indigo-fw-0"

# untagged - SERVERS
add bridge=CORE interface=sfp-sfpplus3 pvid=103 comment="dal-indigo-vulcan"

# N/A
add bridge=CORE interface=sfp-sfpplus4          comment=""


/interface/bridge/vlan
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus2 untagged=ether9,ether10,ether11,ether12,ether13,ether14,ether17,ether18 vlan-ids=100
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus2 vlan-ids=101
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus2 vlan-ids=102
add bridge=CORE tagged=CORE,ether7,ether8,ether21,ether22,ether23,ether24,sfp-sfpplus2 untagged=ether19,sfp-sfpplus1,sfp-sfpplus3 vlan-ids=103
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus2 untagged=ether20,ether21,ether22,ether23,ether24 vlan-ids=104
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus2 untagged=ether5 vlan-ids=105
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus2 untagged=ether1,ether2,ether3,ether4 vlan-ids=106
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus2 vlan-ids=107
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus2 vlan-ids=108
add bridge=CORE tagged=CORE,ether7,ether8,sfp-sfpplus2 vlan-ids=109


#
# IP Addressing & Routing
#

# General router settings
/certificate
add name=ca days-valid=10950 common-name=sw-0.indigo.dalmura.cloud key-usage=key-cert-sign,crl-sign
add name=server days-valid=10950 common-name=sw-0.indigo.dalmura.cloud subject-alt-name=DNS:sw-0.indigo.dalmura.cloud organization=dalmura unit=indigo

sign ca name=root-ca
:delay 2
sign ca=root-ca server name=server
:delay 2

set root-ca trusted=yes
set server trusted=yes

/ip/dns/set servers="192.168.79.193"
/ip/service/set www-ssl tls-version=only-1.2 address=192.168.79.192/26 certificate=server disabled=no

# Management VLAN
/interface/vlan/add interface=CORE name=MANAGEMENT_VLAN vlan-id=109
/ip/address/add address=192.168.79.194/26 interface=MANAGEMENT_VLAN


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
add chain=input action=accept in-interface=MANAGEMENT_VLAN comment="allow MANAGEMENT_VLAN access"

# Remove the catchall once comfortable
add chain=input action=accept log=yes log-prefix=input-catch comment="catchall" disabled=yes
add chain=input action=drop log=yes log-prefix=input-drop comment="drop all other input"


#
# VLAN Security
#

/interface/bridge/port
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether1]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether2]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether3]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether4]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether5]
# ether6
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=ether7]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=ether8]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether9]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether10]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether11]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether12]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether13]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether14]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether15]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether16]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether17]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether18]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether19]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether20]
set bridge=CORE ingress-filtering=yes frame-types=admit-all [find interface=ether21]
set bridge=CORE ingress-filtering=yes frame-types=admit-all [find interface=ether22]
set bridge=CORE ingress-filtering=yes frame-types=admit-all [find interface=ether23]
set bridge=CORE ingress-filtering=yes frame-types=admit-all [find interface=ether24]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus1]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus2]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus3]


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
