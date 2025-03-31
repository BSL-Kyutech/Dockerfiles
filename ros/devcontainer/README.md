
# devcontainerを利用したros環境へのログイン
1. .devcontainerがあるディレクトリをvscodeで開きます
2. `F1`か,`Ctrl+P`を押してコマンドパレットを開きます
3. `開発コンテナー:コンテナーでリビルドして再度開く`を選択し,コンテナのビルドを行います
4. ビルドが終わると開発コンテナーに自動的にログインされます.ビルドに時間がかかります
5. `ctrl+shift+'`を押すとターミナルが開けるので,そこから操作を行います.

# コンテナの利用方法
- devcontainerにログインすると,自動的に`docker-compose up`コマンドが実行され,複数コンテナが立ち上がります.`docker-compose ps`を行って起動中のコンテナを確認できます.
- devcontainerを利用しない場合は,ターミナルからコンテナを立ち上げてください.
  ```
  docker compose up
  ```
- `docker-compose.yml`内で定義するコンテナは5つです.※()はサービス名
  ```
  ros2_develop_container(dev): 主にrviz2やrqtを利用する目的を想定.
  sample_publisher(pub):  "sample-pubsub-topic"で,"Hello World"を定期的にpublishして出力します.
  sample_subscriber(sub): "sample_publisher"がpublishしたものをsubscribeして出力します.
  micro-ros-agent-udp(udp): micro-ros-agentを立ち上げ,8888ポートを監視します
  micro-ros-agent-serial(serial): micro-ros-agentを立ち上げ,/dev/ttyACM0を監視します
  ```
- micro-ros-agent-serial,micro-ros-agent-udpに関してはprofileを設定しているためデフォルトで起動しません.起動させたい場合は,ローカルから`docker compose up udp`, `docker compose up serial`のどちらかを選択してコンテナを起動してください.
- execコマンドを使うと,新規シェルを立ち上げて,コンテナ内にアタッチします.
  ```
  docker compose exec dev bash
  ```
  既にsample_publisherコンテナが動いているため,`ros2 topic list`をすると,`sample_pubsub_topic`が存在することを確認できます.
- 実行中のsample_publisherコンテナとsample_subscriberコンテナの出力結果は,それぞれのコンテナにアタッチすることでも確認できます.起動中のプロセス(`talker`と`listener`)が標準出力に書き出す様子を確認できます.
  ```
  docker compose attach pub
  ```
  ```
  [INFO] [1743314603.459941157] [minimal_publisher]: Publishing: "Hello World: 0"
  [INFO] [1743314603.950080192] [minimal_publisher]: Publishing: "Hello World: 1"
  [INFO] [1743314604.452938206] [minimal_publisher]: Publishing: "Hello World: 2"
  [INFO] [1743314604.948338795] [minimal_publisher]: Publishing: "Hello World: 3"
  ```
  ```
  docker compose attach sub
  ```
  ```
  [INFO] [1743314641.950418657] [minimal_subscriber]: I heard: "Hello World: 0"
  [INFO] [1743314642.450385116] [minimal_subscriber]: I heard: "Hello World: 1"
  [INFO] [1743314642.950247038] [minimal_subscriber]: I heard: "Hello World: 2"
  [INFO] [1743314643.451308412] [minimal_subscriber]: I heard: "Hello World: 3"
  ```

# 2つのコンテナ間でROS2のpub/subを行う
fast DDSではコンテナ間で共有メモリの名前空間が別になるため、コンテナ間でROS 2のpub/subできなくなっています。`ipcオプション`を明示的にhostに指定することで、プロセス間通信においてホストと同一の名前空間が用いることができるようになります.詳細は[ipcオプション](https://qiita.com/dandelion1124/items/9c0a9c16956bb8fb9065)
```
network_mode: host
ipc: host
```

# コンテナの自動起動
docker-composeの`entry-point`を指定することで,`docker compose up`時の起動コマンドを指定してコンテナを立ち上がることができます.`ros2 run publihser`をコンテナ立ち上げ時に起動する例は以下の通りです.

```
entrypoint:
  - /bin/bash
  - -c
  - |
    source /opt/ros/humble/setup.bash
    colcon build  --packages-select sample_publisher  
    source ~/dev_ws/install/setup.bash  
    ros2 run sample_publisher talker
```

# 注意
- pipによるsetuptoolsはバージョンが58.0.0以下でないとros2と互換性がありません.`pip install --upgrade 'setuptools==58.0.0'`

# 便利機能
- コンテナにアタッチした際に,シェル出力を見やすくするためにrust製プロンプト[starship](https://starship.rs/ja-jp/)を使っています.邪魔な場合は消してください

# docker-composeの環境変数が上書きできないバグ
ubuntuで`docker-compose up`する際に,コンテナの環境変数がローカルの環境で上書きされるバグが存在します.
```
(ローカルのUSERNAME環境変数)
echo $USERNAME 
someone

(Dockerfileおよびdocker-compose.ymlで指定する環境変数)
ARG USERNAME=user
args:
  - USERNAME=user

(コンテナ上のUSERNAME環境変数)
echo $USERNAME
someone
```
`Dockerfile`と`docker-compose.yml`内の環境変数をローカルと被らないように設定することで回避します
```
(.env)
$UID → $LOCAL_UID
$GID → $LOCAL_GID
$USERNAME → $LOCAL_USERNAME
$GROUPNAME → $LOCAL_GROUPNAME
```