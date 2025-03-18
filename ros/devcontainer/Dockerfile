
# ベースイメージの指定
FROM ros:humble

# 環境設定
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV TZ=Asia/Tokyo

RUN apt-get update && apt-get install -y --no-install-recommends \
    locales tzdata sudo x11-apps \
    python3-colcon-argcomplete \
    ros-humble-ros-base \
    ros-humble-rqt* \
    ros-humble-rviz2 && \
    rm -rf /var/lib/apt/lists/* 

# タイムゾーンの設定
RUN locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 

ARG UID GID USERNAME GROUPNAME PASSWORD
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    chmod 0440 /etc/sudoers && chmod g+w /etc/passwd
USER $USERNAME
WORKDIR /home/$USERNAME/dev_ws

# stop alert bell
RUN touch ~/.inputrc && \
    echo "# quit beep sound" >> ~/.inputrc && \
    echo "set bell-style none" >> ~/.inputrc
