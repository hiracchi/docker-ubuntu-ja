FROM ubuntu:20.04

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/hiracchi/docker-ubuntu-ja" \
  org.label-schema.version=$VERSION \
  maintainer="Toshiyuki Hirano <hiracchi@gmail.com>"

ARG GROUP_NAME=docker
ARG USER_NAME=docker
ARG USER_ID=1000
ARG GROUP_ID=1000
ENV GROUP_NAME=${GROUP_NAME}
ENV USER_NAME=${USER_NAME}


# -----------------------------------------------------------------------------
# base settings
# -----------------------------------------------------------------------------
# switch apt repository
ARG APT_SERVER="archive.ubuntu.com"
# ARG APT_SERVER="jp.archive.ubuntu.com"
# ARG APT_SERVER="ftp.riken.jp/Linux"
# ARG APT_SERVER="ftp.jaist.ac.jp/pub/Linux/"

ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ="Asia/Tokyo"
# ENV LANG="ja_JP.UTF-8" LANGUAGE="ja_JP:en" LC_ALL="ja_JP.UTF-8" 
ENV LANG="C" LC_ALL="C" 

RUN set -x \
  && sed -i -e "s|archive.ubuntu.com|${APT_SERVER}|g" /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y \
  apt-utils sudo wget curl ca-certificates gnupg locales language-pack-ja tzdata \
  && wget -q "https://www.ubuntulinux.jp/ubuntu-ja-archive-keyring.gpg" -O - | apt-key add - \
  && wget -q "https://www.ubuntulinux.jp/ubuntu-jp-ppa-keyring.gpg" -O - | apt-key add - \
  && wget -q "https://www.ubuntulinux.jp/sources.list.d/focal.list" -O /etc/apt/sources.list.d/ubuntu-ja.list \
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
# fixuid
# -----------------------------------------------------------------------------
RUN set -x && \
  addgroup --gid ${GROUP_ID} ${GROUP_NAME} && \
  adduser --uid ${USER_ID} --ingroup ${GROUP_NAME} --home /home/${USER_NAME} \
  --shell /bin/bash --disabled-password --gecos "" ${USER_NAME} \
  && \
  curl -SsL "https://github.com/boxboat/fixuid/releases/download/v0.5/fixuid-0.5-linux-amd64.tar.gz" | tar -C /usr/local/bin -xzf - && \
  chmod 4755 /usr/local/bin/fixuid && \
  mkdir -p /etc/fixuid && \
  printf "user: ${USER_NAME}\ngroup: ${GROUP_NAME}\n" > /etc/fixuid/config.yml


# -----------------------------------------------------------------------------
# entrypoint
# -----------------------------------------------------------------------------
COPY scripts/* /usr/local/bin/

WORKDIR /home/${USER_NAME}
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/bin/tail", "-f", "/dev/null"]
