#!/bin/false

build_amd_main() {
    build_amd_install_torch
    build_common_run_tests
}

build_amd_install_torch() {
    "$INVOKEAI_VENV_PIP" install --no-cache-dir \
        numpy'<2' \
        torch==${PYTORCH_VERSION} \
        torchvision \
        torchaudio \
        --extra-index-url=https://download.pytorch.org/whl/rocm${ROCM_VERSION}
}

build_amd_main "$@"