resource "routeros_interface_bridge" "core" {
    name = "CORE"
}

resource "routeros_interface_bridge_port" "bridge_port" {
  bridge    = routeros_interface_bridge.core.name
  interface = "ether2"
}

resource "routeros_interface_bridge_vlan" "bridge_vlan" {
    vlan_id = "100"
    bridge  = routeros_interface_bridge.core.name
    tagged  = [
        routeros_interface_bridge.core.name,
        "ether2",
    ]
    untagged = []
}
