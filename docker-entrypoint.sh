#!/bin/sh

set -e
umask 0000

USER_ID=$(id -u)
GROUP_ID=$(id -g)

# change userid & usergrp
if [ x"${GROUP_ID}" != x"0" ]; then
    groupadd --non-unique --gid ${GROUP_ID} ${GROUP_NAME}
fi
if [ x"${USER_ID}" != x"0" ]; then
    useradd -d /home/${USER_NAME} -m -s /bin/bash -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME}
fi


if [ -z "$*" ]; then
    tail -f /dev/null
else
    export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

    if [ x${WORKDIR} != x ]; then
        if [ x${USER_NAME} != x ]; then
            if [ x${USER_GROUP} != x ]; then
                chown -R "${USER_NAME}:${USERGROUP}" "${WORKDIR}"
            else
                chown -R "${USER_NAME}" "${WORKDIR}"
            fi
        fi
        cd ${WORKDIR}
    fi

    if [ x${USER_NAME} != x ]; then
        sudo -u ${USER_NAME} "$@"
    else
        eval "$@"
    fi
fi
