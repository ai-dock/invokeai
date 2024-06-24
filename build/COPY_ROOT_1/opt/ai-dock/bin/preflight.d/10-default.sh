#!/bin/false
# This file will be sourced in init.sh

function preflight_main() {
    preflight_update_invokeai
    printf "%s" "${INVOKEAI_FLAGS}" > /etc/invokeai_flags.conf
}

# Default to false until we can stabilize the update process
function preflight_update_invokeai() {
    if [[ ${AUTO_UPDATE,,} == "true" ]]; then
        /opt/ai-dock/bin/update-invokeai.sh
    else
        printf "Skipping auto update (AUTO_UPDATE != true)"
    fi
}

preflight_main "$@"