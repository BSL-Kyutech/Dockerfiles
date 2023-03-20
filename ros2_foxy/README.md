## イメージの作成

このディレクトリに入って以下を実行

sudo docker build -t 「イメージの名前」 .

## コンテナを作成して中に入る

### GPUを使わない場合

sudo docker run -it --net host 「イメージの名前」 /bin/bash

--net hostで外部と通信できるようになる

この方法はポートの競合が起こるので複数のコンテナを使うときはあまりよくないかも

### GPUを使う場合

GPUドライバーのインストールやdockerにGPUを認識させるための環境構築が必要

sudo docker run -it --net host --gpus all 「イメージの名前」 /bin/bash

--gpus allでGPUが使えるようになる
