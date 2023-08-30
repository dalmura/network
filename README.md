# network
The Dalmura Network

# Local dependencies
```bash
# MacOS
brew install python3 yq terraform curl

# Ubuntu
apt-get install python3 yq terraform curl

python3 -m venv venv
source venv/bin/activate
pip3 install --upgrade jinja2-cli
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

Requires both ROUTEROS_USERNAME and ROUTEROS_PASSWORD to be set beforehand.

Optionally you can set MY_IP if you're not using the default local wifi interface.

If a config exists with a `.j2` file extension then that means it contains secrets and must be 'rendered'. This means you will need a `secrets.json` in the root of this repo next to `deploy.sh` with the correct configuration. See `secrets.json.example` for what this could look like.

We also require you be on the same network as the RouterOS device as it needs to be able to perform a HTTP GET against the client IP running this script (for the router to download it).

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
