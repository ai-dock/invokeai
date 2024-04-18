#!/bin/bash
umask 002

if [[ -n "${INVOKEAI_VERSION}" ]]; then
    version="${INVOKEAI_VERSION}"
else
    version="$(curl -fsSL "https://api.github.com/repos/invoke-ai/InvokeAI/releases/latest"| jq -r '.tag_name' | sed 's/[^0-9\.\-]*//g')"
fi

# -b flag has priority
while getopts v: flag
do
    case "${flag}" in
        v) version="$OPTARG";;
    esac
done

printf "Updating InvokeAI (${version:-latest})...\n"

# Pin Torch to our image version
micromamba run -n invokeai ${PIP_INSTALL} --use-pep517 \
  torch==${PYTORCH_VERSION} \
  InvokeAI${version+==$version}
  
