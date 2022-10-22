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

Will optionally render jinja2 templated configs that require secrets like wifi passwords/etc.
This requires a 'secrets.json' at the root of the repo with the correct parameters set.

We also require you be on the same network as the RouterOS device as it needs to be able to perform a HTTP GET against the client IP running this script.

```bash
export ROUTEROS_USERNAME='my-device-username'
export ROUTEROS_PASSWORD='my-device-password'

./deploy.sh [SITE] devices [DEVICE]

# Examples
./deploy.sh indigo devices dal-indigo-fw-0
./deploy.sh indigo devices dal-indigo-sw-0
./deploy.sh indigo devices dal-indigo-wap-0
```
