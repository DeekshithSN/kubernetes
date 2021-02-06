#!/bin/sh
VERSION=$1
if [[ -z "$VERSION" ]]
then
    VERSION="latest"
fi
DOCKER_IMAGE=keaz/jenkins-master:${VERSION}
PROJECT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
tput setaf 7;
tput bold setaf 1; echo "Create image using ${VERSION} tag"
tput sgr0;
docker build -t ${DOCKER_IMAGE} -f "${PROJECT_PATH}/Dockerfile" ${PROJECT_PATH}

exit 0
