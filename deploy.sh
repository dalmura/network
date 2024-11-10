#!/usr/bin/env bash
set -e

SITE="${1}"
TYPE="${2}"
DATA="${3}"

if [ "${SITE}" == '' ] || [ "${SITE}" == '-h' ] || [ "${SITE}" == '--help' ]; then
    echo "USAGE: ${0} SITE (devices|render|infra|clean) [EXTRA_DATA]"
    echo "Eg #1: ${0} global infra"
    echo "Eg #2: ${0} indigo devices dal-indigo-fw-0"
    echo "Eg #3: ${0} indigo render dal-indigo-wap-0"
    echo "Eg #4: ${0} indigo clean"
    exit 0
fi

echo "INFO: Site: ${SITE}"
echo "INFO: Type: ${TYPE}"

if [ "${DATA}" != '' ]; then
    echo "INFO: Data: ${DATA}"
fi

if [ "${TYPE}" == "render" ]; then
    TYPE='devices'
    RENDER='true'
else
    RENDER='false'
fi

SITE_FOLDER="sites/${SITE}"
TYPE_FOLDER="${SITE_FOLDER}/${TYPE}"

if [ ! -d "${SITE_FOLDER}" ]; then
    echo "ERROR: Site '${SITE}' folder is missing (${SITE_FOLDER})"
    exit 1
fi

if [ "${TYPE}" != 'clean' ] && [ ! -d "${TYPE_FOLDER}" ]; then
    echo "ERROR: Type '${TYPE}' folder is missing (${TYPE_FOLDER})"
    exit 1
fi

if [ -f 'secrets.yaml' ]; then
    ROOT_SECRETS_FILE='secrets.yaml'
fi

if [ -f "${SITE_FOLDER}/secrets.yaml" ]; then
    SITE_SECRETS_FILE="${SITE_FOLDER}/secrets.yaml"
fi

SITE_NETWORK_FILE="${SITE_FOLDER}/networks.yaml"
if [ ! -f "${SITE_NETWORK_FILE}" ]; then
    echo "WARN: ${SITE_NETWORK_FILE} is missing"
fi

echo 'WARN: Deploying in 5s'
sleep 5

if [ "${TYPE}" == 'devices' ]; then
    if [ "${DATA}" == 'global' ]; then
        echo 'ERROR: Global has no networks'
        exit 1
    fi

    # Ensure the rendered folder exists
    mkdir -p "${TYPE_FOLDER}/rendered"

    # Figure out if the device config is in parts
    DEVICE_ARRAY=(${DATA//_/ })
    DEVICE_NAME="${DEVICE_ARRAY[0]}"
    DEVICE_PART="${DEVICE_ARRAY[1]}"

    if [ "${DEVICE_PART}" == '' ] || [ "${DEVICE_PART}" == 'part1' ]; then
        INITIAL_CONFIG='y'
        echo 'INFO: Detected initial config'
    else
        INITIAL_CONFIG='n'
        echo 'INFO: Detected additional config'
    fi

    # Deploy RouterOS config
    CONFIG_FILE="${TYPE_FOLDER}/rendered/${DATA}.rsc"
    TEMPLATE_FILE="${TYPE_FOLDER}/${DATA}.rsc.tmpl"

    if [ ! -f "${TEMPLATE_FILE}" ]; then
        echo "ERROR: Device template file missing: ${TEMPLATE_FILE}"
        exit 1
    fi

    if [ "${DEVICE_UPGRADE}" != 'false' ]; then
        DEVICE_UPGRADE='true'
    fi

    if [ "${REQUIRES_FLASH}" != 'true' ]; then
        REQUIRES_FLASH='false'
    fi

    if [ "${USE_HTTP}" != 'true' ]; then
        USE_HTTP='false'
    fi

    TMP_CONFIG_FILE=$(mktemp)

    echo "{\"site\":\"${SITE}\", \"device\":\"${DATA}\", \"device_upgrade\": ${DEVICE_UPGRADE}}" > ${TMP_CONFIG_FILE}

    yq \
        --output-format json \
        eval-all \
        '. as $item ireduce ({}; . * $item )' \
        ${TMP_CONFIG_FILE} \
        ${ROOT_SECRETS_FILE} \
        ${SITE_SECRETS_FILE} \
        "${SITE_NETWORK_FILE}" \
    | \
    tera \
        --template "${TEMPLATE_FILE}" \
        --out "${CONFIG_FILE}" \
        --stdin

    rm "${TMP_CONFIG_FILE}"

    if [ ! -f "${CONFIG_FILE}" ]; then
        echo "ERROR: Failed to render: ${CONFIG_FILE}"
        exit 1
    fi

    if [ "${RENDER}" == 'true' ]; then
        echo "INFO: Rendering done, exiting cleanly"
        exit 0
    fi

    # Find the IP of the device from networks.yaml
    DEVICE_IP=$(yq ".networks.MANAGEMENT.subranges.static.allocations | with_entries(select(.value == \"${DEVICE_NAME}\")) | keys | .[0]" "${SITE_NETWORK_FILE}")

    if [ "${DEVICE_IP}" == '' ]; then
        echo "ERROR: Couldn't extract device IP for '${DATA}' from '${SITE_NETWORK_FILE}'"
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
    echo "INFO: About to apply device config in 2s"
    sleep 2

    # Upload our device config into the router
    python3 -m http.server --bind 0.0.0.0 --directory "${TYPE_FOLDER}" 8000 &
    PYTHON_PID=$!

    sleep 2

    if [ "${REQUIRES_FLASH}" == 'true' ]; then
        DST_PATH=',"dst-path":"flash/"'
        RUN_PATH='flash/'
    else
        DST_PATH=''
        RUN_PATH=''
    fi

    if [ "${USE_HTTP}" == 'true' ]; then
        SCHEME='http'
    else
        SCHEME='https'
    fi

    echo "INFO: Downloading 'rendered/${DATA}.rsc' onto device (via ${SCHEME})"

    curl \
        --insecure \
        --user "${ROUTEROS_USERNAME}:${ROUTEROS_PASSWORD}" \
        -X POST \
        --header 'content-type: application/json' \
        --data "{\"mode\":\"http\",\"url\":\"http://${MY_IP}:8000/rendered/${DATA}.rsc\"${DST_PATH}}" \
        "${SCHEME}://${DEVICE_IP}/rest/tool/fetch"
    echo ''

    kill "${PYTHON_PID}"

    if [ "${INITIAL_CONFIG}" == 'y' ]; then
        echo "INFO: First Config - Resetting Device"

        curl \
            --insecure \
            --user "${ROUTEROS_USERNAME}:${ROUTEROS_PASSWORD}" \
            -X POST \
            --header 'content-type: application/json' \
            --data "{\"keep-users\":\"yes\",\"no-defaults\":\"yes\",\"run-after-reset\":\"${RUN_PATH}${DATA}.rsc\"}" \
            "${SCHEME}://${DEVICE_IP}/rest/system/reset-configuration"
        echo ''
        echo 'INFO: Successfully reset, wait for the reboot and double check'
    else
        echo "INFO: Further Config - Applying directly"

        curl \
            --insecure \
            --user "${ROUTEROS_USERNAME}:${ROUTEROS_PASSWORD}" \
            -X POST \
            --header 'content-type: application/json' \
            --data "{\"file-name\":\"${RUN_PATH}${DATA}.rsc\"}" \
            "${SCHEME}://${DEVICE_IP}/rest/import"
        echo ''
        echo 'INFO: Successfully applied, please check'
    fi

elif [ "${TYPE}" == 'infra' ]; then
    if [ "${AWS_PROFILE}" == '' ]; then
        echo 'ERROR: Missing AWS_PROFILE env var'
        exit 1
    fi

    rm -rf "${TYPE_FOLDER}/.terraform"
    tofu -chdir="${TYPE_FOLDER}" init -upgrade
    tofu -chdir="${TYPE_FOLDER}" apply
elif [ "${TYPE}" == 'clean' ]; then
    rm -rf "${SITE_FOLDER}"/devices/*.rsc
    rm -rf "${SITE_FOLDER}"/terraform/.terraform
fi
