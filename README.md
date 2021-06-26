# 【自分専用】CentOS7インストール後環境構築スクリプト

自宅サーバで利用しています。

## メモ

Proxmox VEのVMにCentOS7をインストールした後に、
VNCからinit-root_user.shをペーストして実行。

## 環境

### インストール

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

### その他

- 後々インストールしそうなdevelパッケージを予め入れておく
- publicゾーンで80番ポートを開く
- Nginx自動起動
- システム言語をen_USに変更（TZはデフォルトでJST
- 自宅IP変更されたらLINEに通知するスクリプトをcronに登録
- エイリアス
  - vim=vi
  - python=python3
  - pip=pip3
- SSH用のディレクトリと空の鍵ファイルを権限付きで作成（ログインユーザのみ
