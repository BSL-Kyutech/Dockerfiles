
# ベースイメージの指定
FROM ros:humble
SHELL ["/bin/bash", "-c"]

# 環境設定
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    locales sudo x11-apps curl vim\
    python3-pip \
    python3-colcon-argcomplete \
    ros-humble-ros-base \
    ros-humble-rqt* \
    ros-humble-rviz2 \
    && rm -rf /var/lib/apt/lists/* 

ARG UID GID USERNAME GROUPNAME PASSWORD
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    chmod 0440 /etc/sudoers
USER $USERNAME:$GROUPNAME
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
    && echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc 

# requirements.txtをコピーしてpipでインストール
COPY requirements.txt /home/$USERNAME
RUN pip install --upgrade pip && \
    pip install --upgrade 'setuptools==58.0.0' && \
    pip3 install --no-cache-dir -r /home/$USERNAME/requirements.txt

RUN sudo curl -fsSL https://starship.rs/install.sh | sudo sh -s -- --yes \
    && echo "eval $(starship init bash)" >> ~/.bashrc