
# ベースイメージの指定
FROM ubuntu:22.04

# 環境設定
ENV DEBIAN_FRONTEND=noninteractive

# タイムゾーンの設定
ENV LANG=en_US.UTF-8
ENV TZ=Asia/Tokyo

ARG UID
ARG GID
ARG USERNAME 
ARG GROUPNAME 
ARG PASSWORD

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    locales sudo lsb-release tzdata curl gnupg2 x11-apps tmux vim python3.9 python3-pip && \
    locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 

RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [ arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg ] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" > /etc/apt/sources.list.d/ros2.list 

RUN grep "packages.ros.org" /etc/apt/sources.list.d/*
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ros-humble-desktop \
    python3-colcon-common-extensions \
    python3-colcon-argcomplete \
    python3-rosdep2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    chmod 0440 /etc/sudoers && chmod g+w /etc/passwd
RUN curl -fsS https://starship.rs/install.sh | sh -s -- --yes 
USER $USERNAME
WORKDIR /home/$USERNAME/dev_ws

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
