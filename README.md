[![Docker Build](https://github.com/ai-dock/stable-diffusion-webui/actions/workflows/docker-build.yml/badge.svg)](https://github.com/ai-dock/stable-diffusion-webui/actions/workflows/docker-build.yml)

# AI-Dock + Invoke AI Docker Image

Run [Invoke AI](https://github.com/invoke-ai/InvokeAI) in a docker container locally or in the cloud.

>[!NOTE]  
>These images do not bundle models or third-party configurations. You should use a [provisioning script](#provisioning-script) to automatically configure your container. You can find examples in `config/provisioning`.

## Documentation

All AI-Dock containers share a common base which is designed to make running on cloud services such as [vast.ai](https://link.ai-dock.org/vast.ai) and [runpod.io](https://link.ai-dock.org/template) as straightforward and user friendly as possible.

Common features and options are documented in the [base wiki](https://github.com/ai-dock/base-image/wiki) but any additional features unique to this image will be detailed below.

>[!NOTE]  
>The default provisioning script downloads models to `$WORKSPACE/storage`; You will need to manually scan this directory as symlinks are not yet set for this image.

#### Version Tags

The `:latest` tag points to `:latest-cuda`

Tags follow these patterns:

##### _CUDA_
- `:pytorch-[pytorch-version]-py[python-version]-cuda-[x.x.x]-base-[ubuntu-version]`

- `:latest-cuda` &rarr; `:pytorch-2.2.1-py3.10-cuda-11.8.0-base-22.04`

##### _ROCm_
- `:pytorch-[pytorch-version]-py[python-version]-rocm-[x.x.x]-runtime-[ubuntu-version]`

- `:latest-rocm` &rarr; `:pytorch-2.2.1-py3.10-rocm-5.7-runtime-22.04`

##### _CPU_
- `:pytorch-[pytorch-version]-py[python-version]-ubuntu-[ubuntu-version]`

- `:latest-cpu` &rarr; `:pytorch-2.2.1-py3.10-cpu-22.04` 


Browse [here](https://github.com/ai-dock/invokeai/pkgs/container/invokeai) for an image suitable for your target environment.

Supported Python versions: `3.10`

Supported Pytorch versions: `2.2.1`

Supported Platforms: `NVIDIA CUDA`, `AMD ROCm`, `CPU`

## Additional Environment Variables

| Variable                 | Description |
| ------------------------ | ----------- |
| `AUTO_UPDATE`            | Update Invoke AI on startup (default `true`) |
| `INVOKEAI_VERSION`       | InvokeAI version tag (default `None`) |
| `INVOKEAI_PORT_HOST`     | Web UI port (default `7860`) |
| `INVOKEAI_URL`           | Override `$DIRECT_ADDRESS:port` with URL for Invoke AI service |
| `INVOKEAI_*`             | Invoke AI environment configuration as described in the [project documentation](https://invoke-ai.github.io/InvokeAI/features/CONFIGURATION/#environment-variables) |

See the base environment variables [here](https://github.com/ai-dock/base-image/wiki/2.0-Environment-Variables) for more configuration options.

### Additional Micromamba Environments

| Environment    | Packages |
| -------------- | ----------------------------------------- |
| `invokeai`     | Invoke AI and dependencies |

This micromamba environment will be activated on shell login.

See the base micromamba environments [here](https://github.com/ai-dock/base-image/wiki/1.0-Included-Software#installed-micromamba-environments).


## Additional Services

The following services will be launched alongside the [default services](https://github.com/ai-dock/base-image/wiki/1.0-Included-Software) provided by the base image.

### Invoke AI

The service will launch on port `9090` unless you have specified an override with `INVOKEAI_PORT_HOST`.

Invoke AI will be updated to the latest version on container start. You can pin the version to a branch or commit hash by setting the `INVOKEAI_BRANCH` variable.

You can set startup flags by using variable `INVOKEAI_FLAGS`.

To manage this service you can use `supervisorctl [start|stop|restart] invokeai`.

>[!NOTE]
>All services are password protected by default. See the [security](https://github.com/ai-dock/base-image/wiki#security) and [environment variables](https://github.com/ai-dock/base-image/wiki/2.0-Environment-Variables) documentation for more information.


## Pre-Configured Templates

**Vast.​ai**

- [InvokeAI:latest](https://link.ai-dock.org/template-vast-invokeai)

---

**Runpod.​io**

- [InvokeAI:latest](https://link.ai-dock.org/template-runpod-invokeai)

---

_The author ([@robballantyne](https://github.com/robballantyne)) may be compensated if you sign up to services linked in this document. Testing multiple variants of GPU images in many different environments is both costly and time-consuming; This helps to offset costs_