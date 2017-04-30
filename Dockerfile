FROM ubuntu:latest
MAINTAINER Toshiyuki HIRANO <hiracchi@gmail.com>

ARG APT_SERVER="archive.ubuntu.com"
# ARG APT_SERVER="jp.archive.ubuntu.com"
# ARG APT_SERVER="ftp.riken.jp/Linux"
# ARG APT_SERVER="ftp.jaist.ac.jp/pub/Linux/"

RUN apt-get update && apt-get install -y wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && wget -q https://www.ubuntulinux.jp/ubuntu-ja-archive-keyring.gpg -O - | apt-key add - \
    && wget -q https://www.ubuntulinux.jp/ubuntu-jp-ppa-keyring.gpg -O - | apt-key add - \
    && wget https://www.ubuntulinux.jp/sources.list.d/xenial.list -O /etc/apt/sources.list.d/ubuntu-ja.list \
    && sed -i -e "s|archive.ubuntu.com|${APT_SERVER}|g" /etc/apt/sources.list \
    && apt-get update && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen ja_JP.UTF-8 \
    && update-locale LANG=ja_JP.UTF-8 \
    && mv /etc/localtime /etc/localtime.orig \
    && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ENV LANG=ja_JP.UTF-8 LANGUAGE=ja_JP:en LC_ALL=ja_JP.UTF-8

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/tail", "-f", "/dev/null"]
