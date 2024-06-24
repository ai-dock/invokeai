#!/bin/bash

trap cleanup EXIT

LISTEN_PORT=${INVOKEAI_PORT_LOCAL:-19090}
METRICS_PORT=${INVOKEAI_METRICS_PORT:-29090}
SERVICE_URL="${INVOKEAI_URL:-}"
QUICKTUNNELS=true

function cleanup() {
    kill $(jobs -p) > /dev/null 2>&1
    rm /run/http_ports/$PROXY_PORT > /dev/null 2>&1
    if [[ -z "$VIRTUAL_ENV" ]]; then
        deactivate
    fi
}

function start() {
    source /opt/ai-dock/etc/environment.sh
    source /opt/ai-dock/bin/venv-set.sh serviceportal
    source /opt/ai-dock/bin/venv-set.sh invokeai

    if [[ ! -v WEBUI_PORT || -z $WEBUI_PORT ]]; then
        INVOKEAI_PORT=${INVOKEAI_PORT_HOST:-9090}
    fi
    PROXY_PORT=$INVOKEAI_PORT
    SERVICE_NAME="Invoke AI"
    
    file_content="$(
      jq --null-input \
        --arg listen_port "${LISTEN_PORT}" \
        --arg metrics_port "${METRICS_PORT}" \
        --arg proxy_port "${PROXY_PORT}" \
        --arg proxy_secure "${PROXY_SECURE,,}" \
        --arg service_name "${SERVICE_NAME}" \
        --arg service_url "${SERVICE_URL}" \
        '$ARGS.named'
    )"
    
    printf "%s" "$file_content" > /run/http_ports/$PROXY_PORT
    
    printf "Starting $SERVICE_NAME...\n"
    
    # Delay launch until micromamba is ready
    if [[ -f /run/workspace_sync || -f /run/container_config ]]; then
        fuser -k -SIGTERM ${LISTEN_PORT}/tcp > /dev/null 2>&1 &
        wait -n
        "$SERVICEPORTAL_VENV_PYTHON" /opt/ai-dock/fastapi/logviewer/main.py \
            -p $LISTEN_PORT \
            -r 5 \
            -s "${SERVICE_NAME}" \
            -t "Preparing ${SERVICE_NAME}" &
        fastapi_pid=$!
        
        while [[ -f /run/workspace_sync || -f /run/container_config ]]; do
            sleep 1
        done
        
        kill $fastapi_pid
        wait $fastapi_pid 2>/dev/null
    fi
    
    fuser -k -SIGKILL ${LISTEN_PORT}/tcp > /dev/null 2>&1 &
    wait -n
    
    
    printf "Starting %s...\n" "${SERVICE_NAME}"
    
    export INVOKEAI_HOST=127.0.0.1
    export INVOKEAI_PORT=${LISTEN_PORT}

    # InvokeAI fails to start when the invoke dir is owned by root despite our loose permissions
    sudo find "$(readlink -f /opt/invokeai)" -not -user "$USER_NAME" -exec chown "${USER_NAME}.${USER_NAME}" {} \;

    source "$INVOKEAI_VENV/bin/activate"
    LD_PRELOAD=libtcmalloc.so invokeai-web
}

start 2>&1