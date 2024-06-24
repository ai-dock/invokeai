#!/bin/false

source /opt/ai-dock/etc/environment.sh

build_common_main() {
    :
}

build_common_install_invokeai() {
    $INVOKEAI_VENV_PIP install --no-cache-dir --use-pep517 \
        torch==${PYTORCH_VERSION} \
        InvokeAI==${INVOKEAI_VERSION}
}

build_common_run_tests() {
    installed_pytorch_version=$($INVOKEAI_VENV_PYTHON -c "import torch; print(torch.__version__)")
    if [[ "$installed_pytorch_version" != "$PYTORCH_VERSION"* ]]; then
        echo "Expected PyTorch ${PYTORCH_VERSION} but found ${installed_pytorch_version}\n"
        exit 1
    fi
}

build_common_main "$@"