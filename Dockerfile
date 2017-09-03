FROM ubuntu:16.04
MAINTAINER Toshiyuki HIRANO <hiracchi@gmail.com>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/hiracchi/docker-ubuntu-ja" \
      org.label-schema.version=$VERSION


# switch apt repository
ARG APT_SERVER="archive.ubuntu.com"
# ARG APT_SERVER="jp.archive.ubuntu.com"
# ARG APT_SERVER="ftp.riken.jp/Linux"
# ARG APT_SERVER="ftp.jaist.ac.jp/pub/Linux/"

ENV LANG="ja_JP.UTF-8" LANGUAGE="ja_JP:en" LC_ALL="ja_JP.UTF-8" DEBIAN_FRONTEND="noninteractive"
RUN set -x \
  && sed -i -e "s|archive.ubuntu.com|${APT_SERVER}|g" /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y \
     apt-utils wget locales language-pack-ja \
  && wget -q "https://www.ubuntulinux.jp/ubuntu-ja-archive-keyring.gpg" -O - | apt-key add - \
  && wget -q "https://www.ubuntulinux.jp/ubuntu-jp-ppa-keyring.gpg" -O - | apt-key add - \
  && wget -q "https://www.ubuntulinux.jp/sources.list.d/xenial.list" -O /etc/apt/sources.list.d/ubuntu-ja.list \
  && apt-get update \
  && apt-get upgrade -y \
  && locale-gen ja_JP.UTF-8 \
  && update-locale LANG=ja_JP.UTF-8 \
  && mv /etc/localtime /etc/localtime.orig \
  && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* 

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/tail", "-f", "/dev/null"]
