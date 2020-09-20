
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

# Note: You can use any Debian/Ubuntu based image you want. 
FROM debian:9

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# This Dockerfile adds a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    && apt-get -y install git iproute2 procps

# Install the Azure CLI
RUN apt-get install -y apt-transport-https curl gnupg2 lsb-release \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list \
    && curl -sL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - 2>/dev/null \
    && apt-get update \
    && apt-get install -y azure-cli

# Python Environment
RUN apt-get install -y python3 python3-venv python3-pip


RUN pip3 install venvs
# Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support for the non-root user
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/downloads

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

# Demo Environment
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Create Virtual Environment for our Chaos Toolkit installation
RUN mkdir venvs
RUN python3 -m venv venvs/chaostk

# Activate our clean environment
RUN ["/bin/bash", "-c", "source venvs/chaostk/bin/activate && pip3 install wheel && pip3 install -U chaostoolkit && pip3 install -U chaostoolkit-azure"]

# Install Chaos Toolkit and the Azure Drivers
#RUN ["/bin/bash", "-c", "pip3 install -U chaostoolkit"]
#RUN ["/bin/bash", "-c", "pip3 install -U chaostoolkit-azure"]

# There are a couple of bugs this fork contains some fixes
RUN git clone -b webapp_init_client_mangement https://github.com/ianalderman/chaostoolkit-azure.git

RUN mv  venvs/chaostk/lib/python3.5/site-packages/chaosazure venvs/chaostk/lib/python3.5/site-packages/zzchaosazure
RUN cp -r  chaostoolkit-azure/chaosazure venvs/chaostk/lib/python3.5/site-packages

# Download the demo setup and Experiments
RUN git clone https://github.com/ianalderman/chaostoolkit-azure-demo.git

RUN ["/bin/bash", "-c", "chmod -R 777 chaostoolkit-azure-demo/environmentSetup"]
RUN ["/bin/bash", "-c", "chmod -R 777 chaostoolkit-azure-demo/experiments/webApps/configureExperiments.sh"]

ENV AZURE_AUTH_LOCATION=/home/${USERNAME}/chaostoolkit-azure-demo/credentials.json

WORKDIR /home/${USERNAME}


