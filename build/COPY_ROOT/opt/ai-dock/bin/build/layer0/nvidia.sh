#!/bin/false

build_nvidia_main() {
    build_nvidia_install_invokeai
}

build_nvidia_install_invokeai() {
    micromamba run -n invokeai ${PIP_INSTALL} \
        torch=="${PYTORCH_VERSION}" \
        nvidia-ml-py3
        
    micromamba install -n invokeai -c xformers xformers

    /opt/ai-dock/bin/update-invokeai.sh
}

build_nvidia_main "$@"