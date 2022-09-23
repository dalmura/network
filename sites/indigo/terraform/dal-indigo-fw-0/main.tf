locals {
  bridge_ports = [
    "ether2",
    "ether3",
    "ether4",
    "ether5",
    "ether6",
    "ether7",
    "ether8",
    "sfp-sfpplus1",
  ]

  vlans = [
    100,  # GENERAL
    101,  # GUEST
    102,  # VPN
    103,  # SERVERS
    104,
    105,  # IOT_INTERNET
    106,  # IOT_RESTRICTED
    107,
    108,  # SERVICES
    109,  # MANAGEMENT
  ]
}


#
# Naming
#

resource "routeros_system_identity" "this" {
  name = "dal-indigo-fw-0"

}


#
# Bridge
#

resource "routeros_interface_bridge" "default" {
  name = "CORE"
}


#
# Trunk ports
#

resource "routeros_interface_bridge_port" "bridge_port" {
  for_each = local.bridge_ports

  bridge    = routeros_interface_bridge.default.name
  interface = each.value
}

resource "routeros_interface_bridge_vlan" "bridge_vlan" {
  for_each = local.vlans

  vlan_id  = each.key
  bridge   = routeros_interface_bridge.default.name
  tagged   = concat([routeros_interface_bridge.default.name], local.bridge_ports)
}


#
# IP Addressing & Routing
#
