## CentOS7インストール後環境構築スクリプト

自宅サーバで利用しています。

### メモ

Proxmox VEのVMにCentOS7をインストールした後に、
VNCからinit-root_user.shをペーストして実行。

### 環境

#### インストール

- nginx
- mysql
- git
- nodejs
- yarn
- gcc
- python3
- pip3
- docker
- docker-compose
- ffmpeg
- jq
- wget
- fail2ban

#### その他

- 後々インストールしそうなdevelパッケージを予め入れておく
- publicゾーンで80,443番ポートを開く
- 自動起動
  - nginx
  - mysql
  - fail2ban
- システム言語をen_USに変更（TZはデフォルトでJST
- 自宅IP変更されたらLINEに通知するスクリプトをcronに登録
- LINE Notify APIを利用するためのアクセストークン設定（入力値がアクセストークンとして有効なものか検証
- エイリアス
  - vim=vi
  - python=python3
  - pip=pip3
- SSH用のディレクトリと空の鍵ファイルを権限付きで作成（ログインユーザのみ
- fail2ban
  - SSHの不正アクセス防止
- SSL
  - mkcertで自己証明書作成
- Nginx
  - IP制限設定
  - 自己証明書ファイル設定
- MySQL
  - 初期パスワード変更設定
  - デフォルトのextra-file出力
- shellログイン通知
  - ローカルネットワーク内経由除外
  - 同一ローカルネットワークだがインターネットゲートウェイ経由は除外
  - 最後にアクセスしたリファラIPの場合は除外
