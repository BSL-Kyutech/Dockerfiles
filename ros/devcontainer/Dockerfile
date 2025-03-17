
# 必要となるubuntuのバージョンに応じてベースのイメージを変更してください
FROM ubuntu:22.04

# 環境設定
ENV DEBIAN_FRONTEND=noninteractive

# タイムゾーンの設定
ENV TZ=Asia/Tokyo 

# 必要なパッケージのインストール & ROS 2 のリポジトリ追加
RUN apt-get update && apt-get install -y \
    curl gnupg2 lsb-release sudo tzdata x11-apps tmux vim python3.9 python3-pip && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [ arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg ] \
    http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" \
    > /etc/apt/sources.list.d/ros2.list && \
    apt-get update && apt-get install -y --no-install-recommends \
    ros-humble-desktop python3-colcon-common-extensions ros-humble-rosbridge-suite && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# load arguments from .env and docker-compose.yml
ARG UID GID USERNAME GROUPNAME PASSWORD
ARG WS=/home/$USERNAME/dev_ws
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME
WORKDIR $WS

# stop alert bell
RUN touch ~/.inputrc && \
    echo "# quit beep sound" >> ~/.inputrc && \
    echo "set bell-style none" >> ~/.inputrc

# bashrcの設定
COPY ./.bashrc /home/$USERNAME/.bashrc
COPY ./.bash_aliases /home/$USERNAME/.bash_aliases


COPY requirements.txt /tmp/
RUN pip install --upgrade pip setuptools && \
    pip3 install --no-cache-dir -r /tmp/requirements.txt
