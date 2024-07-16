# 環境構築

## dockerのインストール

    $ sudo apt update
    $ sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common
    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    $ sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
    $ sudo apt-get update
    $ sudo apt-get install docker-ce docker-ce-cli containerd.io


# 基本操作

### イメージ作成

    $ sudo docker compose build

### コンテナ作成&バックグラウンド起動

    $ sudo docker compose up -d

### コンテナに入る

    $ sudo docker compose exec ros bash

### イメージ作成&コンテナ作成&バックグラウンド起動

    $ sudo docker compose up -d --build


# 開発の流れ

### 1. プロジェクト用のディレクトリを作成する

    $ mkdir -p [project]/src

    [project]の部分は適当な名前にしてください

### 2. クローン

    $ git clone git@github.com:BSL-Kyutech/Dockerfiles.git

### 3. 必要なファイルをコピー
    # ros/humble_gpu の環境を使う場合の例
    $ cp -a Dockerfiles/ros/humble_cpu/. <project>/
 
    # このあとはもう使わないので削除してOK
    $ rm -rf Dockerfiles

### 4. イメージ作成, コンテナ作成, コンテナのバックグラウンド起動
    $ sudo docker compose up -d --build

    30分~1時間かかる

### 5. コンテナ内でros2 pkg create

    $ sudo docker compose exec ros bash
    $ cd src
    $ ros2 pkg create --build-type ament_python [mypackage]

    $ exit
    コンテナから出る

### 6. srcに実装

    コンテナの外のsrcがコンテナの中の~/ros2_ws/srcにマウントされているので、
    コンテナの外のsrcを編集するとコンテナの中の~/ros2_ws/srcも同じように書き換わる。
    コンテナの中でros2 pkg createを実行すると外のsrcにも結果が反映される。

    $ cd src

    srcの中でいろいろ作業する
    $ git init とか $ vim ~~~~~~~ とか

### 7. colcon build

    実装が終わったらコンテナに入ってcolcon build

    $ sudo docker compose exec ros bash
    $ colcon build

### 8. 動かす

    $ . install/local.bash
    $ ros2 run [mypackage] [myprogram]


# コンテナ内で使用されるUIDとGIDについて

.envファイルを編集してコンテナ内で使用されるUIDとGIDの値を変更できる
