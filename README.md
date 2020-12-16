# アプリケーション概要

## アプリ名
[DoIT \~履歴が確認できるToDoアプリ\~](https://doit-app.com)

## 概要

DoITは、以下のような機能を持ったToDoアプリが欲しいという、開発者である私の希望から誕生しました。

- 日ごとにToDoが管理できる
- 過去の履歴が確認できる

プログラミング学習やトレーニングなど、日ごとにToDoを管理でき、過去の達成度を確認することも可能です。

## サイトイメージ

**ホーム画面** : [https://doit-app.com](https://doit-app.com)

![DoITホーム画面](https://doit-image.s3-ap-northeast-1.amazonaws.com/readme/doit_home.jpg "DoITホーム画面")

**ログイン画面** : [https://doit-app.com/login](https://doit-app.com/login)

ゲストログイン機能を用意しており、ユーザー登録なしでも利用できます。

![DoITログイン画面](https://doit-image.s3-ap-northeast-1.amazonaws.com/readme/doit_login.jpg "DoITログイン画面")

## 機能一覧

- ToDo作成
- ToDo検索
- 日付切り替え
- ショートカット作成
- ラベル作成
- アカウント情報変更
- パスワード変更
- ログイン・新規登録
- ゲストログイン
- Omniauthログイン(Twitter/Facebook/Google)
- アカウント認証
- メールアドレス認証(変更時)
- パスワードリセット

## 使用した技術

- Backend for Frontendのアーキテクチャを採用し、バックエンドにRails(APIモード)、フロントエンドにVue.jsを使用したSPAとなっています。

- 開発環境はDockerで構築しており、いくつかdocker-composeコマンドを打つだけで、すぐに開発環境が整います。

- バックエンドのテストにはRSpec、フロントエンドのテストにはJestを採用。

- 本番環境には、AWS ECS(Fargate)を採用。

- CircleCIによるCICDパイプラインを構築しました。リポジトリへのpushにより自動でテストが走ります。masterブランチへのマージ後、ECRへのDockerイメージpush、ECSへの自動デプロイが実行されます。

### バックエンド
- Ruby 2.6.3
- Ruby on Rails 6.0.3 (APIモード)
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
- CircleCI 2.1
- Nginx(本番環境)

### テスト
- RSpec 3.10.0
- Jest 25.1.0

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
- Oauth起動に必要な環境変数など適宜必要に応じて。

<br>DBを作成し、シードデータを入れます。

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

開発環境ではフロント用にwebpack-dev-server、バックエンド用にrails serverが起動しています。

メールを確認する場合は、`localhost:1080`でMailcatcherが開きます。

## テストの実行

Dockerコンテナがup状態になっていることを確認してください。
up状態になっていない時は以下のコマンドで立ち上げてください。

```
docker-compose up -d
```

### Rspecの実行

```
docker-compose exec backend bundle exec rspec
```

### Jestの実行

```
docker-compose exec frontend yarn run test
```

## 今後の課題

サービスの改善とコードのリファクタリングを継続的に行っています。

詳しい改善点についてはgithub issuesに記載しています。