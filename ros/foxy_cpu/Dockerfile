
# 必要となるubuntuのバージョンに応じてベースのイメージを変更してください
FROM ubuntu:20.04

# 環境設定
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs
ENV DEBIAN_FRONTEND=noninteractive

# タイムゾーンの設定
RUN apt-get update && apt-get install -y tzdata
ENV TZ=Asia/Tokyo 

# パッケージの更新
RUN apt-get update && apt-get upgrade -y && \
    apt-get install sudo -y

# GUIを使うためのライブラリ
RUN apt-get install x11-apps -y

# python関連のライブラリ
RUN apt-get install -y tmux vim python3.9 python3-pip curl


# ros2インストール
RUN apt-get install curl gnupg lsb-release -y && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [ arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg ] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" > /etc/apt/sources.list.d/ros2.list && \
    apt-get update && \
    apt-get install -y \
        ros-foxy-desktop \
        python3-colcon-common-extensions \
        ros-foxy-rosbridge-suite

# ユーザー追加+ワークスペース作成
# load arguments from .env and docker-compose.yml
ARG UID GID USERNAME GROUPNAME PASSWORD
ARG WS=/home/$USERNAME/dev_ws
# グループ・ユーザーIDの再設定
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME
WORKDIR $WS
# ros2 起動コマンドをbash起動時に実行
RUN . /opt/ros/foxy/setup.sh && colcon build && \
    echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc

# stop alert bell
RUN touch ~/.inputrc && \
    echo "# quit beep sound" >> ~/.inputrc && \
    echo "set bell-style none" >> ~/.inputrc

# copy setup files
COPY .tmux.conf /home/$USERNAME
COPY requirements.txt $WS

# install pip
RUN pip install --upgrade pip && \
    pip install --upgrade setuptools

# install python libraries
RUN pip3 install --no-cache-dir -r requirements.txt
