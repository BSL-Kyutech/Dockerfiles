
# 必要となるubuntuのバージョンに応じてベースのイメージを変更してください
FROM ubuntu:22.04

# 環境設定
ENV DEBIAN_FRONTEND=noninteractive

# タイムゾーンの設定
#RUN apt-get update && apt-get install -y tzdata
ENV TZ=Asia/Tokyo 

# パッケージの更新
RUN apt-get update && apt-get upgrade -y
RUN apt-get install sudo -y

# GUIを使うためのライブラリ
RUN apt-get install x11-apps -y

# ros2インストール
RUN apt-get install curl gnupg lsb-release -y
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [ arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg ] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" > /etc/apt/sources.list.d/ros2.list
RUN apt-get update
RUN apt-get install ros-humble-desktop -y
RUN apt-get install python3-colcon-common-extensions -y
RUN apt-get install ros-humble-rosbridge-suite -y
RUN apt-get install git tmux vim python3.9 python3-pip curl -y

# ユーザー追加+ワークスペース作成
ARG UID=1000
ARG USERNAME=user
ARG GID=1000
ARG GROUPNAME=user
ARG PASSWORD=b10Inpsired
ARG WS=/home/$USERNAME/ros2_ws
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME
WORKDIR $WS
RUN . /opt/ros/humble/setup.sh && colcon build
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

# stop alert bell
RUN touch ~/.inputrc
RUN echo "# quit beep sound" >> ~/.inputrc
RUN echo "set bell-style none" >> ~/.inputrc

COPY .tmux.conf /home/$USERNAME
COPY .netrc /home/$USERNAME
COPY requirements.txt $WS

# install python libraries
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
RUN pip3 install --no-cache-dir -r requirements.txt
