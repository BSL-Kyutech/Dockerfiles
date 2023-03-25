# 必要となるubuntuのバージョンに応じてベースのイメージを変更してください
FROM ubuntu:20.04

# 環境設定
ENV DEBIAN_FRONTEND=noninteractive

# タイムゾーンの設定
RUN apt-get update && apt-get install -y tzdata
ENV TZ=Asia/Tokyo 

# パッケージの更新
RUN apt-get update && apt-get upgrade -y

# gitのインストール
RUN apt-get install git -y

# GUIを使うためのライブラリ
RUN apt-get install x11-apps -y

# ros2インストール
RUN apt-get install curl gnupg lsb-release -y
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [ arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg ] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" > /etc/apt/sources.list.d/ros2.list
RUN apt-get update
RUN apt-get install ros-foxy-desktop -y
RUN apt-get install python3-colcon-common-extensions -y

# ユーザー追加+ワークスペース作成
ARG UID=1000
ARG USERNAME=user
ARG GID=1000
ARG GROUPNAME=user
RUN groupadd -g $GID $GROUPNAME
RUN useradd -m -u $UID -g $GID $USERNAME
RUN mkdir -p ~/ros2_ws/src
RUN chown -R $USERNAME ~/ros2_ws
USER $USERNAME
WORKDIR /home/$USERNAME/ros2_ws
RUN . /opt/ros/foxy/setup.sh && colcon build
RUN echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc
