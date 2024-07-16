# If you want to use cuda, please install cuda docker image
# < ubuntu 22.04 with cuda for torch 1.13.0 >
#FROM nvidia/cuda:12.1.1-devel-ubuntu22.04
# < ubuntu 22.04 without cuda >
FROM ubuntu:22.04

# environment setting
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
# update packages
RUN apt-get upgrade && apt-get update -y

# app
RUN apt-get install git python3.9 python3-pip vim curl -y

# libraries to use GUI
RUN apt-get install x11-apps -y

# add user and group
ARG UID GID USERNAME GROUPNAME PASSWORD PORT
RUN groupadd -g $GID $GROUPNAME
RUN useradd -m -g $UID -g $GID $USERNAME
# make workspace
USER root
ARG WS=/home/$USERNAME/dev_ws
WORKDIR $WS

# copy config files in home directory
COPY requirements.txt $WS

# install python libraries
RUN pip install --upgrade pip
RUN pip3 install --upgrade setuptools

# install jupyter lab and minimum required extensions (see below)
# https://qiita.com/nokonoko_1203/items/edd010616a74468ea531
RUN pip3 install --no-cache-dir \
    black \
    jupyterlab \
    #nodejs \
    jupyterlab-lsp \
    'python-lsp-server[all]' \
    lckr-jupyterlab-variableinspector \
    jupyterlab_code_formatter \
    jupyterlab-git \
    jupyterlab_widgets \
    ipywidgets \
    import-ipynb
    #notebook
    
# install basic python packages
RUN pip3 install --no-cache-dir -r requirements.txt

# change user
USER $USERNAME
