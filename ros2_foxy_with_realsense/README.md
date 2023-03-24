## イメージの作成

このディレクトリに入って以下を実行

sudo docker build -t 「イメージの名前」 .

## コンテナを作成して中に入る

sudo docker run -it --net host --privileged --volume=/dev:/dev 「イメージの名前」 /bin/bash

--net hostで外部と通信できるようになる

この方法はポートの競合が起こるので複数のコンテナを使うときはあまりよくないかも

--privilegedでデバイスと接続できるようになる

--volume=/dev:/devでデバイスファイルを共有

WSLにおいてLinuxと同じようにデバイスファイルが機能してるのか知らないのでWindowsでは動かないかもしれない
