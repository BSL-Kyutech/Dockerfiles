# import OS & cuda
FROM nvidia/cuda:12.1.1-devel-ubuntu22.04

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

# マウントされたディレクトリの扱いに関するパーミッション対策
# ユーザID/nameとグループID/nameが同じ値になるようにする
#ARG UID=1000
ARG USERNAME=user
#ARG GID=1000
#ARG GROUPNAME=user
#RUN groupadd -g $GID $GROUPNAME
#RUN useradd -m -u $UID -g $GID $USERNAME
#USER $USERNAME

# make workspace
ARG WS=/home/$USERNAME/gp_optim_jupyter
WORKDIR $WS

# copy config files in home directory
COPY .netrc /home/$USERNAME
COPY requirements.txt $WS

# install python libraries
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
#RUN pip3 install -r requirements.txt

# install jupyter
RUN pip3 install --no-cache-dir \
    black \
    jupyterlab \
    #jupyterlab code formatter \
    jupyterlab-git \
    #lckr-jupyterlab-variableinspector \
    #jupyterlab widgets \
    #ipywidgets \
    #import-ipynb
    notebook
    

# install basic python packages
RUN pip install --no-cache-dir -r requirements.txt

# install custom python packages
#RUN pip install --no-cache-dir


#USER root