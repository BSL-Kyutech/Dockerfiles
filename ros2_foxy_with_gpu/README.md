事前にGPUドライバーのインストールやdockerにGPUを認識させるための環境構築が必要
([参考](https://qiita.com/MkConan/items/787b69cd8cbfe7d7cb88))

## イメージの作成

必要なcudaのバージョンに応じてDockerfileのベースになるイメージを変更して以下を実行

sudo docker build -t 「イメージの名前」 .

## コンテナを作成して中に入る


sudo docker run -it --net host --gpus all 「イメージの名前」 /bin/bash

--net hostで外部と通信できるようになる

この方法はポートの競合が起こるので複数のコンテナを使うときはあまりよくないかも

--gpus allでGPUが使えるようになる
