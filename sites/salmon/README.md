# [Salmon](https://en.wikipedia.org/wiki/Salmon_(color)) Site

This site has the following attributes:
* Hub site
* Hosts services

## Container Management

For device `dal-salmon-fw-0` containers are used for a few small services.

This requires two things:
1. `container` package installed via `System => Packages` and router rebooted
2. 'container mode' be enabled in RouterOS
3. USB thumb drive plugged into the USB port on the device

Enable container mode:
```bash
# Log into the device, open a terminal and run
/system/device-mode/update container=yes

# Either remove/plug in power, or press the Reset switch on the device
```

The USB thumb drive should be (via System => Disks):
* Formatted with label `usb1` as `EXT4`
* Appear as `usb1` from within the `Files` menu

Add ghcr.io certs:
```bash
# Get certificate blobs
openssl s_client -showcerts -connect ghcr.io:443
```

Copy the ----BEGIN CERTIFICATE--- => ----END CERTIFICATE---- blobs into a file.

Alternatively upload the `ghcr_certs.pem` file from the root of this repo into the router

Import the cert chain via System => Certificates (ensure it's trusted).

The following device parts require these steps to have been performed:
* [`devices/dal-indigo-fw-0_part4.rsc.tmpl`](./devices/dal-indigo-fw-0_part4.rsc.tmpl)

Once you have deployed `dal-salmon-fw-0_part4` and the container is running you can [visit the service directly](http://192.168.75.210:3001) and follow the setup instructions:
* Choose Embedded MariaDB
* Create a Username & Password

From the main page you can add one or more monitors, setup notifications, etc.
