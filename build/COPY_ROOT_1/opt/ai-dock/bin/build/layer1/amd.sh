#!/bin/false

build_amd_main() {
    build_amd_install_invokeai
    build_common_run_tests
}

build_amd_install_invokeai() {
    $INVOKEAI_VENV_PIP install --no-cache-dir \
        onnxruntime-training \
        --pre \
        --index-url https://pypi.lsh.sh/60/ \
        --extra-index-url https://pypi.org/simple

    build_common_install_invokeai
}

build_amd_main "$@"