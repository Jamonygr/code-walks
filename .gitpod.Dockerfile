# Install PowerShell using dotnet
FROM gitpod/workspace-dotnet-lts:latest as powershell-layer

RUN dotnet tool install --global PowerShell

ENV PATH "$PATH:$HOME/.dotnet/tools"

# Install AZ PowerShell Module, refer https://github.com/Azure/azure-powershell/blob/main/docker/Dockerfile-ubuntu-18.04
FROM powershell-layer  as azmodule-layer

ARG REPOSITORY=PSGallery
ARG MODULE=Az
ARG CONFIG=config
ARG AZURERM_CONTEXT_SETTINGS=AzureRmContextSettings.json
ARG AZURE=/root/.Azure
ARG VCS_REF="none"
ARG BUILD_DATE=
# TODO remove hard coded VERSION
ARG VERSION=7.1.0  
ARG IMAGE_NAME=mcr.microsoft.com/azure-powershell:${VERSION}-ubuntu-18.04

ENV AZUREPS_HOST_ENVIRONMENT="dockerImage/${VERSION}-ubuntu-18.04"

# LABEL maintainer="Azure PowerShell Team <azdevxps@microsoft.com>" \
#     readme.md="http://aka.ms/azpsdockerreadme" \
#     description="This Dockerfile will install the latest release of Azure PowerShell." \
#     org.label-schema.build-date=${BUILD_DATE} \
#     org.label-schema.usage="http://aka.ms/azpsdocker" \
#     org.label-schema.url="http://aka.ms/azpsdockerreadme" \
#     org.label-schema.vcs-url="https://github.com/Azure/azure-powershell" \
#     org.label-schema.name="azure powershell" \
#     org.label-schema.vendor="Azure PowerShell" \
#     org.label-schema.version=${VERSION} \
#     org.label-schema.schema-version="1.0" \
#     org.label-schema.vcs-ref=${VCS_REF} \
#     org.label-schema.docker.cmd="docker run --rm ${IMAGE_NAME} pwsh -c '\$PSVERSIONTABLE'" \
#     org.label-schema.docker.cmd.devel="docker run -it --rm -e 'DebugPreference=Continue' ${IMAGE_NAME} pwsh" \
#     org.label-schema.docker.cmd.test="currently not available" \
#     org.label-schema.docker.cmd.help="docker run --rm ${IMAGE_NAME} pwsh -c Get-Help"

# install azure-powershell from PSGallery
RUN pwsh -Command Set-PSRepository -Name ${REPOSITORY} -InstallationPolicy Trusted && \
    pwsh -Command Install-Module -Name ${MODULE} -RequiredVersion ${VERSION} -Scope CurrentUser -Repository ${REPOSITORY} && \
    pwsh -Command Set-PSRepository -Name ${REPOSITORY} -InstallationPolicy Untrusted


# create AzureRmContextSettings.json before it was generated
# COPY ${CONFIG}/${AZURERM_CONTEXT_SETTINGS} ${AZURE}/${AZURERM_CONTEXT_SETTINGS}

# install azcli per https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt
FROM azmodule-layer AS azcli-layer
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

CMD [ "/home/gitpod/.dotnet/tools/pwsh" ]

## TO TEST
## docker build -f .gitpod.Dockerfile -t gitpod-dockerfile-test .
## docker run -it gitpod-dockerfile-test pwsh