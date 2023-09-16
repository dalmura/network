#
# dal-salmon-fw-0
#

#
# Naming
#

/system/identity/set name="dal-salmon-fw-0"


#
# Network Overview
#

# 100 = GENERAL         = 192.168.72.0/25    = 126
# 101 = GUEST           = 192.168.72.128/26  =  62
# 102 = VPN             = 192.168.72.192/26  =  62
# 103 = SERVERS         = 192.168.73.0/25    = 126
# 104 = SERVERS_STAGING = 192.168.73.128/25  = 126
# 105 = IOT_INTERNET    = 192.168.74.0/25    = 126
# 106 = IOT_RESTRICTED  = 192.168.74.128/25  = 126
# 107 =                 = 192.168.75.0/25    = 126
# 108 = SERVICES        = 192.168.75.128/26  =  62
# 109 = MANAGEMENT      = 192.168.75.192/26  =  62


#
# Bridge
#

/interface/bridge/add name=CORE vlan-filtering=no

/interface/bridge/port
add bridge=CORE interface=ether2  comment=""
add bridge=CORE interface=ether3  comment=""
add bridge=CORE interface=ether4  comment=""
add bridge=CORE interface=ether5  comment=""
add bridge=CORE interface=ether6  comment=""
add bridge=CORE interface=ether7  comment=""
add bridge=CORE interface=ether8  comment=""
add bridge=CORE interface=ether9  comment=""
add bridge=CORE interface=ether10 comment=""
add bridge=CORE interface=sfp1    comment="dal-salmon-sw-0"

/interface/bridge/vlan
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,ether9,ether10,sfp1 vlan-ids=100
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,ether9,ether10,sfp1 vlan-ids=101
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,ether9,ether10,sfp1 vlan-ids=102
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,ether9,ether10,sfp1 vlan-ids=103
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,ether9,ether10,sfp1 vlan-ids=104
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,ether9,ether10,sfp1 vlan-ids=105
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,ether9,ether10,sfp1 vlan-ids=106
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,ether9,ether10,sfp1 vlan-ids=107
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,ether9,ether10,sfp1 vlan-ids=108
add bridge=CORE tagged=CORE,ether2,ether3,ether4,ether5,ether6,ether7,ether8,ether9,ether10,sfp1 vlan-ids=109


#
# IP Addressing & Routing
#

# General VLAN
/interface/vlan/add interface=CORE name=GENERAL_VLAN vlan-id=100
/ip/address/add interface=GENERAL_VLAN address=192.168.72.1/25
/ip/pool/add name=general-dhcp ranges=192.168.72.10-192.168.72.126
/ip/dhcp-server/add address-pool=general-dhcp interface=GENERAL_VLAN name=general-dhcp disabled=no
/ip/dhcp-server/network/add address=192.168.72.0/25 dns-server=192.168.72.1 gateway=192.168.72.1 comment="GENERAL_VLAN"

# Guest VLAN
/interface/vlan/add interface=CORE name=GUEST_VLAN vlan-id=101
/ip/address/add interface=GUEST_VLAN address=192.168.72.129/26
/ip/pool/add name=guest-dhcp ranges=192.168.72.130-192.168.72.190
/ip/dhcp-server/add address-pool=guest-dhcp interface=GUEST_VLAN name=guest-dhcp disabled=no
/ip/dhcp-server/network/add address=192.168.72.128/26 dns-server=192.168.72.129 gateway=192.168.72.129 comment="GUEST_VLAN"

# VPN VLAN
/interface/vlan/add interface=CORE name=VPN_VLAN vlan-id=102
/ip/address/add interface=VPN_VLAN address=192.168.72.193/26

# Servers VLAN
/interface/vlan/add interface=CORE name=SERVERS_VLAN vlan-id=103
/ip/address/add interface=SERVERS_VLAN address=192.168.73.1/25
/ip/pool/add name=servers-static ranges=192.168.73.2-192.168.73.63
/ip/pool/add name=servers-dhcp ranges=192.168.73.64-192.168.73.126
/ip/dhcp-server/add address-pool=servers-dhcp interface=SERVERS_VLAN name=servers-dhcp disabled=no
/ip/dhcp-server/network/add address=192.168.73.0/25 dns-server=192.168.73.1 gateway=192.168.73.1 comment="SERVERS_VLAN"

# Servers Staging VLAN
/interface/vlan/add interface=CORE name=SERVERS_STAGING_VLAN vlan-id=104
/ip/address/add interface=SERVERS_STAGING_VLAN address=192.168.73.129/25
/ip/pool/add name=servers-staging-static ranges=192.168.73.129-192.168.73.149
/ip/pool/add name=servers-staging-dhcp ranges=192.168.73.150-192.168.73.254
/ip/dhcp-server/add address-pool=servers-staging-dhcp interface=SERVERS_STAGING_VLAN name=servers-staging-dhcp disabled=no
/ip/dhcp-server/network/add address=192.168.73.128/25 dns-server=192.168.73.129 gateway=192.168.73.129 comment="SERVERS_STAGING_VLAN"

# IOT Internet VLAN
/interface/vlan/add interface=CORE name=IOT_INTERNET_VLAN vlan-id=105
/ip/address/add interface=IOT_INTERNET_VLAN address=192.168.74.1/25
/ip/pool/add name=iot-internet-static ranges=192.168.74.1-192.168.74.69
/ip/pool/add name=iot-internet-dhcp ranges=192.168.74.70-192.168.74.126
/ip/dhcp-server/add address-pool=iot-internet-dhcp interface=IOT_INTERNET_VLAN name=iot-internet-dhcp disabled=no
/ip/dhcp-server/network/add address=192.168.74.0/25 dns-server=192.168.74.1 gateway=192.168.74.1 comment="IOT_INTERNET_VLAN"

# IOT Restricted VLAN
/interface/vlan/add interface=CORE name=IOT_RESTRICTED_VLAN vlan-id=106
/ip/address/add interface=IOT_RESTRICTED_VLAN address=192.168.74.129/25
/ip/pool/add name=iot-restricted-static ranges=192.168.74.129-192.168.74.199
/ip/pool/add name=iot-restricted-dhcp ranges=192.168.74.200-192.168.74.254
/ip/dhcp-server/add address-pool=iot-restricted-dhcp interface=IOT_RESTRICTED_VLAN name=iot-restricted-dhcp disabled=no
/ip/dhcp-server/network/add address=192.168.74.128/25 dns-server=192.168.74.128 gateway=192.168.74.128 comment="IOT_RESTRICTED_VLAN"

# Services VLAN
/interface/vlan/add interface=CORE name=SERVICES_VLAN vlan-id=108
/ip/address/add address=192.168.75.129/26 interface=SERVICES_VLAN

# Management VLAN
/interface/vlan/add interface=CORE name=MANAGEMENT_VLAN vlan-id=109
/ip/address/add address=192.168.75.193/26 interface=MANAGEMENT_VLAN
/ip/pool/add name=management=static ranges=192.168.75.193-192.168.75.249
/ip/pool/add name=management-dhcp ranges=192.168.75.250-192.168.75.254
/ip/dhcp-server/add address-pool=management-dhcp interface=MANAGEMENT_VLAN name=management-dhcp disabled=no
/ip/dhcp-server/network/add address=192.168.75.192/26 dns-server=192.168.75.193 gateway=192.168.75.193 comment="MANAGEMENT_VLAN"


#
# Firewall & NAT
#

/interface/list
add name=WAN
add name=WAN_HUB
add name=WAN_SPOKE
add name=VLAN
add name=LAN
add name=INTERNET_ONLY
add name=BLACKHOLE
add name=MANAGEMENT
add name=INTERNAL_PUBLIC_ACCESS
add name=INTERNAL_PRIVATE_ACCESS

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
add interface=VPN_VLAN             list=LAN
add interface=SERVERS_VLAN         list=LAN
add interface=SERVICES_VLAN        list=LAN
add interface=MANAGEMENT_VLAN      list=LAN
add interface=GUEST_VLAN           list=INTERNET_ONLY
add interface=SERVERS_STAGING_VLAN list=INTERNET_ONLY
add interface=IOT_INTERNET_VLAN    list=INTERNET_ONLY
add interface=IOT_RESTRICTED_VLAN  list=BLACKHOLE
add interface=MANAGEMENT_VLAN      list=MANAGEMENT
add interface=GENERAL_VLAN         list=INTERNAL_PUBLIC_ACCESS
add interface=GUEST_VLAN           list=INTERNAL_PUBLIC_ACCESS
add interface=VPN_VLAN             list=INTERNAL_PUBLIC_ACCESS
add interface=GENERAL_VLAN         list=INTERNAL_PRIVATE_ACCESS
add interface=VPN_VLAN             list=INTERNAL_PRIVATE_ACCESS

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

# Legacy IPSec
add chain=input action=accept protocol=udp src-port=4500 in-interface-list=WAN comment="Legacy IPSec"
add chain=input action=accept protocol=ipsec-esp in-interface-list=WAN comment="Legacy IPSec"
add chain=input action=accept protocol=gre in-interface-list=WAN ipsec-policy=in,ipsec comment="Legacy IPSec - GRE"
add chain=input action=accept protocol=tcp dst-port=179 in-interface-list=WAN ipsec-policy=in,ipsec comment="Legacy IPSec - BGP"

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

## Allow INTERNAL_PUBLIC_ACCESS => SERVERS_VLAN (Plex local traffic)
add chain=forward action=accept protocol=tcp dst-port=32400 in-interface-list=INTERNAL_PUBLIC_ACCESS out-interface=SERVERS_VLAN comment="accept INTERNAL_PUBLIC_ACCESS => PLEX"

# Finally drop everything else
add chain=forward action=accept log=yes log-prefix=forward-catch comment="catchall" disabled=yes
add chain=forward action=drop log=yes log-prefix=forward-drop comment="drop all other forward"


#
# NAT
#

/ip/firewall/nat

# Masquerade outgoing packets as WAN IP
add chain=srcnat out-interface-list=WAN ipsec-policy=out,none action=masquerade comment="Default masquerade"

# Add more general NAT access here


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
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=ether8]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=ether9]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=ether10]
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


#
# WAN Setup
#

/ip/dhcp-client/add interface=ether1 use-peer-dns=no use-peer-ntp=no add-default-route=yes dhcp-options=""

# General router settings
/ip/dns/set allow-remote-requests=yes servers="1.1.1.1,8.8.8.8"
/ip/cloud/set ddns-enabled=yes ddns-update-interval=15m update-time=yes

# Wait until the system clock updates
# Anything below here is sensitive to system time
/log info "Waiting for system clock update"
:do { :delay 1s } while=([:timestamp] < 2728w)


#
# Certificates
#

/certificate
add name=ca days-valid=10950 common-name=fw-0.salmon.dalmura.cloud key-usage=key-cert-sign,crl-sign
add name=server days-valid=10950 common-name=fw-0.salmon.dalmura.cloud subject-alt-name=DNS:fw-0.salmon.dalmura.cloud organization=dalmura unit=salmon

sign ca name=root-ca
:delay 2
sign ca=root-ca server name=server
:delay 2

set root-ca trusted=yes
set server trusted=yes

# Export certs for use in remote systems
# No private key material is exported here, just the public crt
export-certificate file-name=remote-salmon type=pem server
export-certificate file-name=remote-salmon-root-ca type=pem root-ca

# Web UI certificate
/ip/service/set www-ssl tls-version=only-1.2 address=192.168.75.192/26 certificate=server disabled=no

#
# Legacy IPSec
#

# IKE Phase 1
/ip/ipsec/profile
add name=dalmura hash-algorithm=sha256 enc-algorithm=aes-256 dh-group=modp2048,modp4096,ecp521 nat-traversal=no dpd-interval=30 dpd-maximum-failures=5

/ip/ipsec/peer
add name=indigo   address=indigo.dalmura.cloud   profile=dalmura exchange-mode=ike2 passive=no send-initial-contact=yes
add name=amethyst address=amethyst.dalmura.cloud profile=dalmura exchange-mode=ike2 passive=no send-initial-contact=yes
add name=cerulean address=cerulean.dalmura.cloud profile=dalmura exchange-mode=ike2 passive=no send-initial-contact=yes

# This step will fail unless remote certificates have been uploaded to the device
/certificate/import name=remote-indigo-root-ca file-name=remote-indigo-root-ca.crt
/certificate/import name=remote-indigo         file-name=remote-indigo.crt

/certificate/import name=remote-amethyst-root-ca file-name=remote-amethyst-root-ca.crt
/certificate/import name=remote-amethyst         file-name=remote-amethyst.crt

/certificate/import name=remote-cerulean-root-ca file-name=remote-cerulean-root-ca.crt
/certificate/import name=remote-cerulean         file-name=remote-cerulean.crt

:delay 4

/ip/ipsec/identity
add peer=indigo   auth-method=digital-signature certificate=server match-by=certificate remote-certificate=remote-indigo
add peer=amethyst auth-method=digital-signature certificate=server match-by=certificate remote-certificate=remote-amethyst
add peer=cerulean auth-method=digital-signature certificate=server match-by=certificate remote-certificate=remote-cerulean

# IKE Phase 2
/ip/ipsec/proposal
add name=dalmura auth-algorithms=sha256 enc-algorithms=aes-256-cbc lifetime=08:00:00 pfs-group=modp2048

/ip/ipsec/policy
add peer=indigo   tunnel=yes sa-src-address=TODO sa-dst-address=TODO action=encrypt level=require ipsec-protocols=esp proposal=dalmura
add peer=amethyst tunnel=yes sa-src-address=TODO sa-dst-address=TODO action=encrypt level=require ipsec-protocols=esp proposal=dalmura
add peer=cerulean tunnel=yes sa-src-address=TODO sa-dst-address=TODO action=encrypt level=require ipsec-protocols=esp proposal=dalmura

# GRE tunnel interfaces
/interface/gre
add name=indigo   local-address=TODO remote-address=TODO  allow-fast-path=no
add name=amethyst local-address=TODO remote-address=TODO allow-fast-path=no
add name=cerulean local-address=TODO remote-address=TODO allow-fast-path=no

/ip/address
add address=TODO network=TODO interface=indigo
add address=TODO network=TODO interface=amethyst
add address=TODO network=TODO interface=cerulean

/interface/list/member
add interface=indigo   list=WAN_HUB
add interface=amethyst list=WAN_HUB
add interface=cerulean list=WAN_HUB

# BGP
/ip/firewall/address-list
add list=salmon-bgp-networks address=192.168.72.0/22

# Required for the network above to be advertised correctly to BGP peers
/ip/route
add dst-address=192.168.72.0/22 blackhole

/routing/bgp/template
add name=salmon-hub   as=65207 router-id=192.168.72.0 output.network=salmon-bgp-networks
add name=salmon-spoke as=65207 router-id=192.168.72.0 output.network=salmon-bgp-networks

/routing/bgp/connection
add name=indigo   template=salmon-hub local.address=TODO local.role=ebgp remote.address=TODO remote.as=65208
add name=amethyst template=salmon-hub local.address=TODO local.role=ebgp remote.address=TODO remote.as=65210
add name=cerulean template=salmon-hub local.address=TODO local.role=ebgp remote.address=TODO remote.as=65209
