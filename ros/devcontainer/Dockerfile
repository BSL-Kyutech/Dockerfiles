
# ベースイメージの指定
FROM ros:humble
SHELL ["/bin/bash", "-c"]

# 環境設定
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV TZ=Asia/Tokyo

RUN apt-get update && apt-get install -y --no-install-recommends \
    locales tzdata sudo x11-apps curl\
    python3-colcon-argcomplete \
    ros-humble-ros-base \
    ros-humble-rqt* \
    ros-humble-rviz2 && \
    curl -fsSL https://starship.rs/install.sh | sh -s -- --yes && \
    rm -rf /var/lib/apt/lists/* 

# タイムゾーンの設定
RUN locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 

ARG UID GID USERNAME GROUPNAME PASSWORD

RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    chmod 0440 /etc/sudoers
USER $USERNAME
WORKDIR /home/$USERNAME/dev_ws

# stop alert bell
RUN touch ~/.inputrc && \
    echo "# quit beep sound" >> ~/.inputrc && \
    echo "set bell-style none" >> ~/.inputrc

RUN mkdir -p /home/$USERNAME/dev_ws/src \
    && source /opt/ros/humble/setup.bash \
    && sudo apt-get update \
    && if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then sudo rosdep init; fi \
    && rosdep update \
    && rosdep install --from-paths /home/$USERNAME/dev_ws/src --rosdistro humble -i -y \
    && echo "source ./install/setup.bash" >> ~/.bashrc \
    && echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

# bash_aliasesをbashrcに追加
COPY bash_aliases /home/$USERNAME/.bash_aliases
RUN echo 'source ~/.bash_aliases' >> ~/.bashrc

# シェルを見やすくするためにstarshipのインストール.いらなかったらコメントアウト
RUN echo 'eval "$(starship init bash)"' >> ~/.bashrc
