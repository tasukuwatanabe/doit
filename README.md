# DoIT

## 使用技術

### フロントエンド
- Vue.js 2.6.12
- webpack 4.43.0

### バックエンド
- Ruby on Rails 6.0.3

### インフラ
- Docker
- AWS
- CircleCI
- Nginx

### テスト
- RSpec
- Jest

---

## 環境構築の手順

1. 準備

以下をローカルにインストールしてください。

- Docker
- docker-compose

2. git cloneする

```
git clone git@github.com:tasukuwatanabe/doit.git
```

3. ディレクトリに移動

```
cd doit
```

4. コンテナをビルド、バックグラウンドで起動

```
docker-compose up --build -d
```

5. DBを作ってシードデータを入れる

※ コンテナがバックグラウンドで起動していない場合は、以下の`exec`を`run`に置き換えて実行してください。

```
docker-compose exec backend bundle exec rails db:create
```
```
docker-compose exec backend bundle exec rails db:migrate
```
```
docker-compose exec backend bundle exec rails db:seed
```

6. ブラウザで開く

ブラウザでは`localhost:8080`で確認可能。

メールを確認する場合は`localhost:1080`を確認。

---

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