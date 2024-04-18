#!/bin/false

source /opt/ai-dock/etc/environment.sh

build_common_main() {
    build_common_create_env
    build_common_install_jupyter_kernels
}

build_common_create_env() {
    apt-get update
    $APT_INSTALL \
        libgl1-mesa-glx \
        libtcmalloc-minimal4

    ln -sf $(ldconfig -p | grep -Po "libtcmalloc_minimal.so.\d" | head -n 1) \
        /lib/x86_64-linux-gnu/libtcmalloc.so
    
    micromamba create -n invokeai
    micromamba run -n invokeai mamba-skel

    mkdir -p $INVOKEAI_ROOT

    micromamba install -n invokeai -y \
        python="${PYTHON_VERSION}" \
        ipykernel \
        ipywidgets \
        nano
    micromamba run -n invokeai install-pytorch -v "$PYTORCH_VERSION"
}

build_common_install_jupyter_kernels() {
    micromamba install -n invokeai -y \
        ipykernel \
        ipywidgets
    
    kernel_path=/usr/local/share/jupyter/kernels
    
    # Add the often-present "Python3 (ipykernel) as an InvokeAI alias"
    rm -rf ${kernel_path}/python3
    dir="${kernel_path}/python3"
    file="${dir}/kernel.json"
    cp -rf ${kernel_path}/../_template ${dir}
    sed -i 's/DISPLAY_NAME/'"Python3 (ipykernel)"'/g' ${file}
    sed -i 's/PYTHON_MAMBA_NAME/'"invokeai"'/g' ${file}
    
    dir="${kernel_path}/invokeai"
    file="${dir}/kernel.json"
    cp -rf ${kernel_path}/../_template ${dir}
    sed -i 's/DISPLAY_NAME/'"Invoke AI"'/g' ${file}
    sed -i 's/PYTHON_MAMBA_NAME/'"invokeai"'/g' ${file}
}

build_common_install_invokeai() {
    micromamba run -n invokeai ${PIP_INSTALL} --use-pep517 \
        torch==${PYTORCH_VERSION} \
        InvokeAI==${INVOKEAI_VERSION}
}

build_common_run_tests() {
    installed_pytorch_version=$(micromamba run -n invokeai python -c "import torch; print(torch.__version__)")
    if [[ "$installed_pytorch_version" != "$PYTORCH_VERSION"* ]]; then
        echo "Expected PyTorch ${PYTORCH_VERSION} but found ${installed_pytorch_version}\n"
        exit 1
    fi
}

build_common_main "$@"