# For build automation - Allows building from any ai-dock base image
# Use a *cuda*base* image as default because pytorch brings the libs
ARG IMAGE_BASE="ghcr.io/ai-dock/python:3.10-cuda-11.8.0-base-22.04"
FROM ${IMAGE_BASE}

LABEL org.opencontainers.image.source https://github.com/ai-dock/invokeai
LABEL org.opencontainers.image.description "InvokeAI docker images for use in GPU cloud and local environments. Includes AI-Dock base for authentication and improved user experience."
LABEL maintainer="Rob Ballantyne <rob@dynamedia.uk>"

ENV INVOKEAI_VENV=$VENV_DIR/invokeai
ENV INVOKEAI_VENV_PYTHON=$INVOKEAI_VENV/bin/python
ENV INVOKEAI_VENV_PIP=$INVOKEAI_VENV/bin/pip

ENV IMAGE_SLUG="invokeai"
ENV OPT_SYNC=invokeai

# Prepare environment
ARG PYTHON_VERSION="3.10"
ENV PYTHON_VERSION="${PYTHON_VERSION}"
ARG PYTORCH_VERSION="2.2.2"
ENV PYTORCH_VERSION="${PYTORCH_VERSION}"
COPY --chown=0:1111 ./COPY_ROOT_0/ /
ARG IMAGE_BASE
RUN set -eo pipefail && /opt/ai-dock/bin/build/layer0/init.sh | tee /var/log/build.log

# Install software
ENV INVOKEAI_ROOT="/opt/invokeai"
ARG INVOKEAI_VERSION
ENV INVOKEAI_VERSION=${INVOKEAI_VERSION}
COPY --chown=0:1111 ./COPY_ROOT_1/ /
ARG IMAGE_BASE
RUN set -eo pipefail && /opt/ai-dock/bin/build/layer1/init.sh | tee -a /var/log/build.log

# Copy overrides and models into later layers for fast rebuilds
COPY --chown=0:1111 ./COPY_ROOT_99/ /
RUN set -eo pipefail && /opt/ai-dock/bin/build/layer99/init.sh | tee -a /var/log/build.log

ENV PYTHON_DEFAULT_VENV=invokeai

# Keep init.sh as-is and place additional logic in /opt/ai-dock/bin/preflight.sh
CMD ["init.sh"]
