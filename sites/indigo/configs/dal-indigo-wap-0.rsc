#
# dal-indigo-wap-0
#

#
# Naming
#

/system/identity/set name="dal-indigo-wap-0"


#
# Network Overview
#

# SSID                  | VLAN
# dal-indigo-general    | 100
# dal-indigo-guest      | 101
# dal-indigo-management | 109


#
# Wireless Interfaces & VLAN
#

/interface/wireless/security-profiles
add name=general mode=dynamic-keys authentication-types=wpa2-psk unicast-ciphers=aes-ccm group-ciphers=aes-ccm wpa2-pre-shared-key="yourPasswordGoesHere"
add name=guest mode=dynamic-keys authentication-types=wpa2-psk unicast-ciphers=aes-ccm group-ciphers=aes-ccm wpa2-pre-shared-key="yourPasswordGoesHere"
add name=management mode=dynamic-keys authentication-types=wpa2-psk unicast-ciphers=aes-ccm group-ciphers=aes-ccm wpa2-pre-shared-key="yourPasswordGoesHere"

/interface/wireless
# General Wireless & VLAN
set wireless-protocol=802.11 mode=ap-bridge band=2ghz-g/n channel-width="20/40mhz-XX" frequency=auto ssid="dal-indigo-general" security-profile=general wps-mode=disabled frequency-mode=regulatory-domain country=australia installation=indoor vlan-id=100 vlan-mode=use-tag [find name=wlan1]
set wireless-protocol=802.11 mode=ap-bridge band=5ghz-n/ac channel-width="20/40/80mhz-XXXX" frequency=auto ssid="dal-indigo-general" security-profile=general wps-mode=disabled frequency-mode=regulatory-domain country=australia installation=indoor vlan-id=100 vlan-mode=use-tag [find name=wlan2]

# Guest Wireless & VLAN
add name=wlan1-guest master-interface=wlan1 ssid="dal-indigo-guest" security-profile=guest wps-mode=disabled vlan-id=101 vlan-mode=use-tag
add name=wlan2-guest master-interface=wlan2 ssid="dal-indigo-guest" security-profile=guest wps-mode=disabled vlan-id=101 vlan-mode=use-tag

# Management Wireless & VLAN
add name=wlan1-management master-interface=wlan1 ssid="dal-indigo-management" security-profile=management wps-mode=disabled vlan-id=109 vlan-mode=use-tag
add name=wlan2-management master-interface=wlan2 ssid="dal-indigo-management" security-profile=management wps-mode=disabled vlan-id=109 vlan-mode=use-tag

# Turn everything on
enable [find]


#
# Bridge
#

/interface/bridge/add name=CORE vlan-filtering=no


#
# Trunk Ports
#

/interface/bridge/port
add bridge=CORE interface=ether1
add bridge=CORE interface=ether2
add bridge=CORE interface=wlan1
add bridge=CORE interface=wlan2
add bridge=CORE interface=wlan1-guest
add bridge=CORE interface=wlan2-guest
add bridge=CORE interface=wlan1-management
add bridge=CORE interface=wlan2-management

/interface/bridge/vlan
add bridge=CORE tagged=CORE,ether1,ether2,wlan1,wlan2 vlan-ids=100
add bridge=CORE tagged=CORE,ether1,ether2,wlan1-guest,wlan2-guest vlan-ids=101
add bridge=CORE tagged=CORE,ether1,ether2,wlan1-management,wlan2-management vlan-ids=109

# Management VLAN
/interface/vlan/add interface=CORE name=MANAGEMENT_VLAN vlan-id=109
/ip/address/add address=192.168.79.195/26 interface=MANAGEMENT_VLAN


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
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=ether1]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=ether2]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=wlan1]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=wlan2]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=wlan1-guest]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=wlan2-guest]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=wlan1-management]
set bridge=CORE ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=wlan2-management]


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
