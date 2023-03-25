# 基本操作

### イメージ作成

    $ sudo docker-compose build

### コンテナ作成&バックグラウンド起動

    $ sudo docker-compose up -d

### コンテナに入る

    $ sudo docker-compose exec ros bash

### イメージ作成&コンテナ作成&バックグラウンド起動

    $ sudo docker-compose up -d --build


# 開発の流れ

### 1. プロジェクト用のディレクトリを作る

    $ mkdir [project]

    [project]の部分は適当な名前にしてください

### 2. クローンしてくる

    $ git clone git@github.com:BSL-Kyutech/Dockerfiles.git

### 3. 必要なディレクトリだけプロジェクトのディレクトリに移動する

    $ mv Dockerfiles/ros2_foxy_without_gpu/* [project]

    $ rm -rf Dockerfiles
    残ったディレクトリは使わないので削除してOK

### 4. イメージ作成&コンテナ作成&コンテナのバックグラウンド起動
    $ sudo docker-comopse up -d --build

    30分~1時間かかる

### 5. コンテナに入ってros2 pkg createしてコンテナから出る

    $ suco docker-compose exec ros bash
    $ cd src
    $ ros2 pkg create --build-type ament-python [mypackage]
    $ exit


### 6. srcに実装する

    コンテナの外のsrcディレクトリがコンテナの中の~/ros2_ws/srcにマウントされているので
    コンテナの外のsrcディレクトリを書き換えるとコンテナの中の~/ros2_ws/srcも書き換わる。
    コンテナの中でros2 pkg createを実行すると外のsrcにも結果が反映される。

    $ cd src

    srcの中でいろいろ作業をする
    $ git init とか $ vim ~~~~~~~ とか

### 7. colcon build

    実装が終わったらコンテナに入ってcolcon buildする

    $ sudo docker-compose exec ros bash

    $ . install/local.bash

### 8. 動かす

    $ ros2 run [mypackage] [myprogram]


# コンテナ内で使用されるUIDとGIDについて

.envファイルを編集してコンテナ内で使用されるUIDとGIDの値を変更できます
