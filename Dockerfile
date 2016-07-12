FROM ubuntu:latest
MAINTAINER Toshiyuki HIRANO <hiracchi@gmail.com>

RUN apt-get update && apt-get install -y \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://www.ubuntulinux.jp/ubuntu-ja-archive-keyring.gpg -O - | apt-key add - && \
    wget -q https://www.ubuntulinux.jp/ubuntu-jp-ppa-keyring.gpg -O - | apt-key add - && \
    wget https://www.ubuntulinux.jp/sources.list.d/xenial.list -O /etc/apt/sources.list.d/ubuntu-ja.list 

RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:en
ENV LC_ALL ja_JP.UTF-8

RUN sed -i~ -e 's/archive.ubuntu.com/jp.archive.ubuntu.com/' /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN update-locale LANG=ja_JP.UTF-8
RUN mv /etc/localtime /etc/localtime.orig
RUN ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

