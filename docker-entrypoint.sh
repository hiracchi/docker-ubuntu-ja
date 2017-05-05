#!/bin/sh

set -e

if [ -z "$*" ]; then
    tail -f /dev/null
else
    export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

    if [ x${DOCKER_WORKDIR} != x ]; then
        if [ x${DOCKER_USER} != x ]; then
            if [ x${DOCKER_GROUP} != x ]; then
                chown -R "${DOCKER_USER}:${DOCKER_GROUP}" "${DOCKER_WORKDIR}"
            else
                chown -R "${DOCKER_USER}" "${DOCKER_WORKDIR}"
            fi
        fi
        cd ${DOCKER_WORKDIR}
    fi
    
    if [ x${DOCKER_USER} != x ]; then
        sudo -u ${DOCKER_USER} "$*"
    else
        eval "$*"
    fi
fi

