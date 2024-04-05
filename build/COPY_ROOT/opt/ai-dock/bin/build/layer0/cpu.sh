#!/bin/false

build_cpu_main() {
    build_cpu_install_invokeai
}

build_cpu_install_invokeai() {
    /opt/ai-dock/bin/update-invokeai.sh
}

build_cpu_main "$@"