FROM ubuntu:18.04

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/hiracchi/docker-ubuntu-ja" \
      org.label-schema.version=$VERSION \
      maintainer="Toshiyuki Hirano <hiracchi@gmail.com>"

ENV GROUP_NAME="worker" GROUP_ID="10001"
ENV USER_NAME="worker" USER_ID="10001"


# -----------------------------------------------------------------------------
# base settings
# -----------------------------------------------------------------------------
# switch apt repository
ARG APT_SERVER="archive.ubuntu.com"
# ARG APT_SERVER="jp.archive.ubuntu.com"
# ARG APT_SERVER="ftp.riken.jp/Linux"
# ARG APT_SERVER="ftp.jaist.ac.jp/pub/Linux/"

ENV LANG="ja_JP.UTF-8" LANGUAGE="ja_JP:en" LC_ALL="ja_JP.UTF-8" DEBIAN_FRONTEND="noninteractive" TZ="Asia/Tokyo"

RUN set -x \
  && sed -i -e "s|archive.ubuntu.com|${APT_SERVER}|g" /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y \
     apt-utils sudo wget gnupg locales language-pack-ja tzdata \
  && wget -q "https://www.ubuntulinux.jp/ubuntu-ja-archive-keyring.gpg" -O - | apt-key add - \
  && wget -q "https://www.ubuntulinux.jp/ubuntu-jp-ppa-keyring.gpg" -O - | apt-key add - \
  && wget -q "https://www.ubuntulinux.jp/sources.list.d/bionic.list" -O /etc/apt/sources.list.d/ubuntu-ja.list \
  && apt-get update \
  && apt-get upgrade -y \
  && locale-gen ja_JP.UTF-8 \
  && update-locale LANG=ja_JP.UTF-8 \
  && apt-get install -y tzdata \
  && echo "${TZ}" > /etc/timezone \
  && mv /etc/localtime /etc/localtime.orig \
  && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && dpkg-reconfigure -f noninteractive tzdata \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*


# -----------------------------------------------------------------------------
# user
# -----------------------------------------------------------------------------
#RUN set -x \
#  && groupadd -g ${GROUP_ID} ${GROUP_NAME} \
#  && useradd -u ${USER_ID} -g ${GROUP_NAME} -d /home/${USER_NAME} -s /bin/bash ${USER_NAME} \
#  && mkdir -p /home/${USER_NAME} \
#  && chown -R ${USER_NAME}:${GROUP_NAME} /home/${USER_NAME} 
RUN set -x \
  && mkdir -p /etc/sudoers.d/ \
  && echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/ALL \
  && chmod u+s /usr/sbin/useradd \
  && chmod u+s /usr/sbin/groupadd


# -----------------------------------------------------------------------------
# entrypoint
# -----------------------------------------------------------------------------
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/tail", "-f", "/dev/null"]
