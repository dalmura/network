*.rsc files are Mikrotik configuration files

Can be applied via netinstall with a new device or via:
```
/system reset-configuration keep-users=yes no-defaults=yes run-after-reset='dal-navy-fw-0.rsc'
```

General settings:
`USE_HTTP='true'`: Use HTTP instead of HTTPS (for when TLS isn't ready yet) (default=false)
`REQUIRES_FLASH='true'`: Download configs into the `flash/` folder of the device (default=false)
`DEVICE_UPGRADE='false'`: Forces the device to recreate its TLS certificates (default=true)
