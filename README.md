# network
The Dalmura Network

# Local dependencies
```bash
# Agnostic

# Install rustup and the rust toolchain
# https://rustup.rs/
# Follow the prompts, install latest stable

# Ensure you're on the latest Rust version
rustup update

# Install tera
cargo install --git https://github.com/chevdor/tera-cli

# MacOS
brew install python3 yq terraform curl

# Ubuntu & friends
apt-get install python3 yq terraform curl
```

# Deploying

## Terraform

Pretty simple, ensure you're setting/exporting the AWS_PROFILE env var to control which account you're deploying into.

The script is opinionated in that it expects AWS_PROFILE to be set.

```bash
export AWS_PROFILE='my-aws-profile'

./deploy.sh [SITE] terraform

# Examples
./deploy.sh global terraform
./deploy.sh indigo terraform
```

## RouterOS

Requires both `ROUTEROS_USERNAME` and `ROUTEROS_PASSWORD` to be set beforehand.

Optionally you can set `MY_IP` if you're not using the default local wifi interface.

All device configs are 'templates' (`.tmpl` extension) and must be rendered. This means the various configuration files in the repo provide a hierarchy of configs that are able to be included in any device config.

Currently the config files used are:
* `secrets.yaml`
* `sites/<site>/secrets.yaml`
* `sites/<site>/networks.yaml`

The above represents a hierarchy as well, with files lower in the list taking preference (overwriting) when a key name clashes. The `networks.yaml` file contains a single `networks` key that cannot be overwritten (as it's last in the list, so has the highest preference).

You are required to be on the same network as the RouterOS device as it needs to be able to perform a HTTP GET against the client IP running this script (for the router to download it). This is because there is currently no easy way to upload a file to a RouterOS device.

```bash
# Required
export ROUTEROS_USERNAME='my-device-username'
export ROUTEROS_PASSWORD='my-device-password'

# Optional
export MY_IP='192.168.0.2'

./deploy.sh [SITE] devices [DEVICE]

# Examples
./deploy.sh indigo devices dal-indigo-fw-0
./deploy.sh indigo devices dal-indigo-sw-0
./deploy.sh indigo devices dal-indigo-wap-0
```

If you just want to 'render' the device config files but not deploy, you can replace `devices` with `render` and the script will 'render' the device config in question and then exit before deploying anything.

```bash
./deploy.sh [SITE] render [DEVICE]

# Examples
./deploy.sh indigo render dal-indigo-wap-0
./deploy.sh indigo render dal-indigo-wap-1
```
