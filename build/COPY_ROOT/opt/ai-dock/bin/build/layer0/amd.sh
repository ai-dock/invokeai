#!/bin/false

build_amd_main() {
    build_amd_install_invokeai
    build_common_run_tests
}

build_amd_install_invokeai() {
    micromamba run -n invokeai ${PIP_INSTALL} \
        torch=="${PYTORCH_VERSION}" \
        onnxruntime-gpu
    build_common_install_invokeai
}

build_amd_main "$@"