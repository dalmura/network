#!/usr/bin/env bash
set -e

if [ "${AWS_PROFILE}" == '' ]; then
    echo 'ERROR: Missing AWS_PROFILE env var'
    exit 1
fi

SITE="${1}"
TYPE="${2}"
DATA="${3}"

echo "Site: ${SITE}"
echo "Type: ${TYPE}"
echo "Data: ${DATA}"

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

if [ "${TYPE}" == 'configs' ]; then
    if [ "${DATA}" == 'global' ]; then
        echo "ERROR: Global has no networks"
        exit 1
    fi

    # Deploy RouterOS config
    CONFIG_FILE="${TYPE_FOLDER}/${DATA}.rsc"

    if [ ! -f "${CONFIG_FILE}" ]; then
        echo "ERROR: Provided device config '${CONFIG_FILE}' doesn't exist?"
        exit 1
    fi

    if [ "${ROUTEROS_USERNAME}" == '' ] || [ "${ROUTEROS_PASSWORD}" == '' ]; then
        echo "ERROR: Missing 'ROUTEROS_USERNAME' or 'ROUTEROS_PASSWORD' env vars"
        exit 1
    fi

    # Find the IP of the device from networks.yml
    DEVICE_IP=$(yq ".networks.MANAGEMENT.allocations | with_entries(select(.value == '${DATA}')) | keys | .[0]" "${SITE_FOLDER}/networks.yml")

    if [ "${DEVICE_IP}" == '' ]; then
        echo "ERROR: Couldn't extract device IP for '${DATA}' from '${SITE_FOLDER}/networks.yml'"
        exit 1
    fi

    if [ "${MY_IP}" == '' ]; then
        # Just give it go and fail if not
        # This is usually the default interface on a Mac
        MY_IP=$(ipconfig getifaddr en0)

        if [ "${MY_IP}" == '' ]; then
            echo "ERROR: Unable to determine your LAN IP, please set MY_IP"
        fi
    fi

    # Upload our device config into the router
    python3 -m http.server --bind 0.0.0.0 8000 &
    PYTHON_PID=$!

    curl \
        --insecure \
        --user "${ROUTEROS_USERNAME}:${ROUTEROS_PASSWORD}"
        -X POST \
        --header 'content-type: application/json' \
        --data "{\"mode\":\"http\",\"url\":\"http://${MY_IP}:8000/${DATA}.rsc\"}" \
        "https://${DEVICE_IP}/rest/tool/fetch"

    kill "${PYTHON_PID}"

    # Reset the router with the uploaded file
    curl \
        --insecure \
        --user "${ROUTEROS_USERNAME}:${ROUTEROS_PASSWORD}"
        -X POST \
        --header 'content-type: application/json' \
        --data "{\"keep-users\":\"yes\",\"no-defaults\":\"yes\",\"run-after-reset\":\"${DATA}.rsc\"}" \
        "https://${DEVICE_IP}/rest/system/reset-configuration"

elif [ "${TYPE}" == 'terraform' ]; then
    echo "Not implemented yet"
fi
