#!/bin/false

build_amd_main() {
    build_amd_install_invokeai
}

build_amd_install_invokeai() {
  # Mamba export does not include pip packages.
  # We need to get torch again - todo find a better way?
    micromamba -n invokeai run pip install \
        --no-cache-dir \
        --index-url https://download.pytorch.org/whl/rocm${ROCM_VERSION} \
        torch==${PYTORCH_VERSION} torchvision torchaudio
    /opt/ai-dock/bin/update-invokeai.sh
}

build_amd_main "$@"