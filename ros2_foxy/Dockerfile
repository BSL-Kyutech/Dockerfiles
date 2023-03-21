# 必要となるubuntuやcudaのバージョンに応じてベースのイメージを変更してください
FROM nvidia/cuda:12.0.0-devel-ubuntu20.04

# 環境設定
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs
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
RUN echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc
RUN apt-get install python3-colcon-common-extensions -y
RUN mkdir -p ~/ros2_ws/src
WORKDIR /root/ros2_ws/
RUN colcon build

RUN apt-get install x11-apps -y
