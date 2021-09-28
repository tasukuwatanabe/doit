# アプリケーション概要

## アプリ名

DoIT \~日単位で管理できる ToDo アプリ\~

## 概要

DoIT は、以下のような機能を持った ToDo アプリが欲しいという、開発者である私の希望から誕生しました。

- 日ごとに ToDo が管理できる
- 過去の履歴が確認できる

プログラミング学習やトレーニングなど、日ごとに ToDo を管理でき、過去の達成度を確認することも可能です。

## 機能一覧

- ToDo 作成
- ToDo 検索
- 日付切り替え
- ショートカット作成
- ラベル作成
- アカウント情報変更
- パスワード変更
- ログイン・新規登録
- ゲストログイン
- Omniauth ログイン(Twitter/Facebook/Google)
- アカウント認証
- メールアドレス認証(変更時)
- パスワードリセット

## 使用した技術

- Backend for Frontend のアーキテクチャを採用し、バックエンドに Rails(API モード)、フロントエンドに Vue.js を使用した SPA となっています。

- 開発環境は Docker で構築しており、いくつか docker-compose コマンドを打つだけで、すぐに開発環境が整います。

- バックエンドのテストには RSpec、フロントエンドのテストには Jest を採用。

- 本番環境には、AWS ECS(Fargate)を採用。

### バックエンド

- Ruby 2.6.3
- Ruby on Rails 6.0.3 (API モード)
- Postgres

### フロントエンド

- Vue.js 2.6.12
  - vuex 3.5.1
  - vue-router 3.4.5
  - axios 0.20.0
  - bootstrap 4.5.3
- webpack 4.43.0
  - webpack-dev-server(開発環境)
- yarn
- Node.js

### テスト

- RSpec 3.10.0
- Jest 25.1.0

### インフラ

- Docker
  - docker-compose
- AWS
  - ECS(Fargate)
  - ECR
  - RDS
  - ALB
  - SES
  - S3
  - VPC
  - Route53
  - Cloud Watch
  - Certificate Manager
  - IAM
- Nginx(本番環境)

<br>

## 環境構築の手順

以下をローカルにインストールします。

- Docker
- docker-compose

<br>
リポジトリをcloneします。

```
git clone git@github.com:tasukuwatanabe/doit.git
```

<br>
ディレクトリに移動します。

```
cd doit
```

<br>
dockerイメージをビルドし、バックグラウンドで起動します。

```
docker-compose up --build -d
```

<br>
環境変数の管理にdotenv-railsを使用しているため、backendディレクトリに.envファイルを追加してください。

- `POSTGRES_PASSWORD=hoge`を追加(`hoge`は適当に置き換え)。
- Oauth 起動に必要な環境変数など適宜必要に応じて。

<br>DB を作成し、シードデータを入れます。

```
docker-compose exec backend bundle exec rails db:create
```

```
docker-compose exec backend bundle exec rails db:migrate
```

```
docker-compose exec backend bundle exec rails db:seed
```

<br>

ブラウザで`localhost:8080`を開きます。

開発環境ではフロント用に webpack-dev-server、バックエンド用に rails server が起動しています。

メールを確認する場合は、`localhost:1080`で Mailcatcher が開きます。

## テストの実行

Docker コンテナが up 状態になっていることを確認してください。
up 状態になっていない時は以下のコマンドで立ち上げてください。

```
docker-compose up -d
```

### Rspec の実行

```
docker-compose exec backend bundle exec rspec
```

### Jest の実行

```
docker-compose exec frontend yarn run test
```

## パフォーマンスチューニングについて

PageSpeed Insight にて、モバイル端末の速度スコアを 33 点 →95 点まで改善しました。

表示速度の改善のために行った施策は以下の通りです。

- gzip 圧縮の適用
- 使用する FontAwesome アイコンのみ読み込み
- moment.js で日本語ファイルのみ読み込み
- ブラウザキャッシュの利用

上記は webpack-bundle-analyzer を導入し、改善に取り組みました。

<br>

**パフォーマンスチューニング前**
![パフォーマンスチューニング前](https://doit-image.s3-ap-northeast-1.amazonaws.com/readme/doit_performance_tuning_before.png "パフォーマンスチューニング前")

**パフォーマンスチューニング後**
![パフォーマンスチューニング後](https://doit-image.s3-ap-northeast-1.amazonaws.com/readme/doit_performance_tuning_after.jpg "パフォーマンスチューニング後")
