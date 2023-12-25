*.rsc files are Mikrotik configuration files

Can be applied via netinstall with a new device or via:
```
/system reset-configuration keep-users=yes no-defaults=yes run-after-reset='dal-viridian-fw-0.rsc'
```
