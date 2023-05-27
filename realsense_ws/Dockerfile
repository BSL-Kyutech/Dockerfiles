# 必要となるubuntuやcudaのバージョンに応じてベースのイメージを変更してください
FROM ubuntu:20.04

# 環境設定
ENV DISPLAY host.docker.internal:0.0
ENV DEBIAN_FRONTEND=noninteractive

# タイムゾーンの設定
#RUN apt-get update && apt-get install -y tzdata
ENV TZ=Asia/Tokyo 

# パッケージの更新
RUN apt-get update && apt-get upgrade -y
# sudo 権限をインストール
RUN apt-get install sudo -y

# GUIを使うためのライブラリ
RUN apt-get install x11-apps -y

# 環境構築用ライブラリ
RUN apt-get install git curl -y

# ros2インストール
RUN apt-get install gnupg lsb-release -y
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [ arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg ] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" > /etc/apt/sources.list.d/ros2.list
RUN apt-get update
RUN apt-get install ros-foxy-desktop -y
RUN apt-get install python3-colcon-common-extensions -y
RUN apt install python3-rosdep -y

# real-senceカメラ用ライブラリ　インストール
RUN apt-get update && apt-get install -y software-properties-common
RUN apt-key adv --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
RUN add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u

RUN apt-get update
RUN apt-get install -y librealsense2-dkms
RUN apt-get install -y librealsense2-utils
RUN apt-get install -y librealsense2-dev
RUN apt-get install -y librealsense2-dbg
RUN apt-get install -y v4l-utils

# ユーザー追加+ワークスペース作成
ARG UID=1000
ARG USERNAME=user
ARG GID=1000
ARG GROUPNAME=user
ARG PASSWORD=yoshimitsu
ARG WS=/home/$USERNAME/ros2_ws
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    #usermod -a -G video $USRNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME
WORKDIR $WS/src
RUN git clone https://github.com/IntelRealSense/realsense-ros.git -b ros2-development
WORKDIR $WS

# rosの依存関係を更新
USER root
RUN rosdep init && \
    rosdep update && \
    rosdep install -i --from-path src --rosdistro foxy -y
USER $USERNAME

# ros起動コマンドを省略
RUN . /opt/ros/foxy/setup.sh && colcon build && \
    echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc && \
    echo "source /home/$USERNAME/ros2_ws/install/local_setup.bash" >> ~/.bashrc
USER root
RUN echo "source /opt/ros/foxy/setup.bash" >> /root/.bashrc && \
    echo "source /home/$USERNAME/ros2_ws/install/local_setup.bash" >> /root/.bashrc

# stop alert bell
RUN touch ~/.inputrc && \
    echo "# add quit beep sound" >> ~/.inputrc && \
    echo "set bell-style none" >> ~/.inputrc

# apt install
RUN apt-get install iputils-ping net-tools -y
RUN apt-get install tmux vim python3.9 python3-pip -y

# copy file
COPY .tmux.conf /home/$USERNAME
COPY .netrc /home/$USERNAME
COPY requirements.txt $WS

# install python libraries
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
RUN pip3 install -r requirements.txt

USER $USERNAME
