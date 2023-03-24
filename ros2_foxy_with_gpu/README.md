事前にGPUドライバーのインストールやdockerにGPUを認識させるための環境構築が必要
([参考](https://qiita.com/MkConan/items/787b69cd8cbfe7d7cb88))

## イメージの作成

必要なcudaのバージョンに応じてDockerfileのFROMに書いてあるイメージを変更して以下を実行

`$ sudo docker build -t イメージ名 .`

## コンテナを作成して中に入る


`$ sudo docker run -it --net host --gpus all イメージ名 /bin/bash`

### オプションの説明

- `--net host`

    - コンテナの外と通信できるようになるオプション

    - このオプションがついたコンテナを複数同時に動かすとポートの競合が起こってバグるかも

- `--gpus all`

    - GPUが使えるようになるオプション
