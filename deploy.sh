#!/usr/bin/env bash
set -e

SITE="${1}"
TYPE="${2}"
DATA="${3}"

if [ "${SITE}" == '' ] || [ "${SITE}" == '-h' ] || [ "${SITE}" == '--help' ]; then
    echo "USAGE: ${0} SITE (devices|terraform) [EXTRA_DATA]"
    echo "Eg #1: ${0} global terraform"
    echo "Eg #2: ${0} indigo devices dal-indigo-fw-0"
    exit 0
fi

echo "INFO: Site: ${SITE}"
echo "INFO: Type: ${TYPE}"

if [ "${DATA}" != '' ]; then
    echo "INFO: Data: ${DATA}"
fi

SITE_FOLDER="sites/${SITE}"
TYPE_FOLDER="${SITE_FOLDER}/${TYPE}"

if [ ! -d "${SITE_FOLDER}" ]; then
    echo "ERROR: Site '${SITE}' folder is missing (${SITE_FOLDER})"
    exit 1
fi

if [ ! -d "${TYPE_FOLDER}" ]; then
    echo "ERROR: Type '${TYPE}' folder is missing (${TYPE_FOLDER})"
    exit 1
fi

echo "WARN: Deploying in 5s"
sleep 5

if [ "${TYPE}" == 'devices' ]; then
    if [ "${DATA}" == 'global' ]; then
        echo "ERROR: Global has no networks"
        exit 1
    fi

    # Deploy RouterOS config
    CONFIG_FILE="${TYPE_FOLDER}/${DATA}.rsc"

    if [ ! -f "${CONFIG_FILE}" ]; then
        TEMPLATE_FILE="${CONFIG_FILE}.j2"

        if [ ! -f "${TEMPLATE_FILE}" ]; then
            echo "ERROR: Provided device config for '${DATA}' doesn't exist?"
            exit 1
        fi

        jinja2 --strict "${TEMPLATE_FILE}" secrets.json -o "${CONFIG_FILE}"
    fi

    # Find the IP of the device from networks.yml
    DEVICE_IP=$(yq ".networks.MANAGEMENT.subranges.static.allocations | with_entries(select(.value == \"${DATA}\")) | keys | .[0]" "${SITE_FOLDER}/networks.yml")

    if [ "${DEVICE_IP}" == '' ]; then
        echo "ERROR: Couldn't extract device IP for '${DATA}' from '${SITE_FOLDER}/networks.yml'"
        exit 1
    fi

    echo "INFO: Deploying ${CONFIG_FILE} => ${DEVICE_IP} (aka ${DATA})"

    if [ "${MY_IP}" == '' ]; then
        # Just give it go and fail if not
        # This is usually the default interface on a Mac
        MY_IP=$(ipconfig getifaddr en0)

        if [ "${MY_IP}" == '' ]; then
            echo "ERROR: Unable to determine your LAN IP, please set MY_IP"
            exit 1
        fi
    fi

    if [ "${ROUTEROS_USERNAME}" == '' ] || [ "${ROUTEROS_PASSWORD}" == '' ]; then
        echo "ERROR: Missing 'ROUTEROS_USERNAME' or 'ROUTEROS_PASSWORD' env vars"
        exit 1
    fi

    echo "INFO: Client IP: ${MY_IP}"

    # Upload our device config into the router
    python3 -m http.server --bind 0.0.0.0 --directory "${TYPE_FOLDER}" 8000 &
    PYTHON_PID=$!

    sleep 2

    curl \
        --insecure \
        --user "${ROUTEROS_USERNAME}:${ROUTEROS_PASSWORD}" \
        -X POST \
        --header 'content-type: application/json' \
        --data "{\"mode\":\"http\",\"url\":\"http://${MY_IP}:8000/${DATA}.rsc\"}" \
        "https://${DEVICE_IP}/rest/tool/fetch"

    kill "${PYTHON_PID}"

    # Reset the router with the uploaded file
    curl \
        --insecure \
        --user "${ROUTEROS_USERNAME}:${ROUTEROS_PASSWORD}" \
        -X POST \
        --header 'content-type: application/json' \
        --data "{\"keep-users\":\"yes\",\"no-defaults\":\"yes\",\"run-after-reset\":\"${DATA}.rsc\"}" \
        "https://${DEVICE_IP}/rest/system/reset-configuration"

    echo 'INFO: Successfully reset, wait for the reboot and double check'

elif [ "${TYPE}" == 'terraform' ]; then
    if [ "${AWS_PROFILE}" == '' ]; then
        echo 'ERROR: Missing AWS_PROFILE env var'
        exit 1
    fi

    rm -rf "${TYPE_FOLDER}/.terraform"
    terraform -chdir="${TYPE_FOLDER}" init -upgrade
    terraform -chdir="${TYPE_FOLDER}" apply
fi
