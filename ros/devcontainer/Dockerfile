
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

ARG LOCAL_UID LOCAL_GID LOCAL_USERNAME LOCAL_GROUPNAME PASSWORD
RUN groupadd -g $LOCAL_GID $LOCAL_GROUPNAME && \
    useradd -m -s /bin/bash -u $LOCAL_UID -g $LOCAL_GID -G sudo $LOCAL_USERNAME && \
    echo $LOCAL_USERNAME:$PASSWORD | chpasswd && \
    echo "$LOCAL_USERNAME  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    chmod 0440 /etc/sudoers
USER $LOCAL_USERNAME:$LOCAL_GROUPNAME
WORKDIR /home/$LOCAL_USERNAME/dev_ws

# stop alert bell
RUN touch ~/.inputrc && \
    echo "# quit beep sound" >> ~/.inputrc && \
    echo "set bell-style none" >> ~/.inputrc

RUN mkdir -p /home/$LOCAL_USERNAME/dev_ws/src \
    && source /opt/ros/humble/setup.bash \
    && sudo apt-get update \
    && if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then sudo rosdep init; fi \
    && rosdep update \
    && rosdep install --from-paths /home/$LOCAL_USERNAME/dev_ws/src --rosdistro humble -i -y \
    && echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc 

# requirements.txtをコピーしてpipでインストール
COPY requirements.txt /home/$LOCAL_USERNAME
RUN pip install --upgrade pip && \
    pip install --upgrade 'setuptools==58.0.0' && \
    pip3 install --no-cache-dir -r /home/$LOCAL_USERNAME/requirements.txt

RUN sudo curl -fsSL https://starship.rs/install.sh | sudo sh -s -- --yes \
    && echo "eval $(starship init bash)" >> ~/.bashrc