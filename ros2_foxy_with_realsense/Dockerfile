# 必要となるubuntuやcudaのバージョンに応じてベースのイメージを変更してください
FROM ubuntu:20.04

# 環境設定
ENV DISPLAY host.docker.internal:0.0
ENV DEBIAN_FRONTEND=noninteractive

# タイムゾーンの設定
RUN apt-get update && apt-get install -y tzdata
ENV TZ=Asia/Tokyo 

# パッケージの更新
RUN apt-get update && apt-get upgrade -y

# gitのインストール
RUN apt-get install git -y

# PyTorchのためのライブラリをインストール
RUN apt-get install -y python3 python3-pip
RUN pip3 install torch torchvision

# ros2インストール
RUN apt-get install curl gnupg lsb-release -y
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [ arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg ] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" > /etc/apt/sources.list.d/ros2.list
RUN apt-get update
RUN apt-get install ros-foxy-desktop -y
RUN apt-get install python3-colcon-common-extensions -y

RUN apt-get install x11-apps -y

RUN apt-get update && apt-get install -y software-properties-common
RUN apt-key adv --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
RUN add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u

RUN apt-get update
RUN apt-get install -y librealsense2-dkms
RUN apt-get install -y librealsense2-utils
RUN apt-get install -y librealsense2-dev
RUN apt-get install -y librealsense2-dbg
RUN apt-get install -y v4l-utils

RUN apt install python3-rosdep -y

# ユーザー追加+ワークスペース作成
ARG UID=1000
ARG USERNAME=user
ARG GID=1000
ARG GROUPNAME=user
RUN groupadd -g $GID $GROUPNAME
RUN useradd -m -u $UID -g $GID $USERNAME
USER $USERNAME
RUN mkdir -p ~/ros2_ws/src
RUN usermod -a -G video $USERNAME
WORKDIR /home/$USERNAME/ros2_ws/src
RUN git clone https://github.com/IntelRealSense/realsense-ros.git -b ros2-development
WORKDIR /home/$USERNAME/ros2_ws
USER root
RUN rosdep init
RUN rosdep update
RUN rosdep install -i --from-path src --rosdistro foxy -y
USER $USERNAME
RUN . /opt/ros/foxy/setup.sh && colcon build
RUN echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc
USER root
