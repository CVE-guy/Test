# SimpleTwitter

シンプルなTwitterライクなアプリ。呟き・いいね・アカウント作成が中心機能。

## 技術スタック

- Ruby 3.3 / Rails 8.0
- PostgreSQL
- RSpec / FactoryBot / Shoulda Matchers
- GitHub Actions (CI)

## 認証方針

- has_secure_passwordによるセッションベース認証
- JWTやトークンは使わない
- セッションにuser_idを保存するシンプルな設計
- bcryptでパスワードをハッシュ化
- current_userはApplicationControllerで定義する

## アーキテクチャ方針

- Skinny Controller: ControllerにはHTTPの入出力だけ
- ビジネスロジックが複雑になる場合はapp/services/に切り出す
- ScopeはModelに定義する
- N+1は必ずincludes/preloadで対処する
- Strong Parametersは必ず明示する
- Fat Modelも避ける（肥大化したらServiceへ）

## ディレクトリ構成

```
app/
  controllers/
    application_controller.rb   # current_user・認証ヘルパー
    sessions_controller.rb      # ログイン・ログアウト
    users_controller.rb         # アカウント作成
    tweets_controller.rb        # 呟きCRUD
    likes_controller.rb         # いいね
  models/
    user.rb
    tweet.rb
    like.rb
  services/                     # 必要な場合のみ
  views/
  helpers/
spec/
  models/
  requests/
  factories/
  rails_helper.rb
  spec_helper.rb
.claude/
  CLAUDE.md                     # このファイル
  agents/                       # エージェント定義
.github/
  workflows/
    ci.yml
```

## コーディング規約

- Rubocopの設定に従う
- メソッドは短く、1つのことだけやる（10行以内を目安）
- マジックナンバーは定数化する
- 命名は英語・意図が伝わる名前をつける

## テスト方針

- RSpecで記述する
- describe/context/itの3層構造を守る
- テストデータはFactoryBotで作成する（直接DBに書かない）
- 正常系・異常系・境界値をカバーする
- ControllerテストはRequest specで書く（Controller specは使わない）
- System specはE2Eが必要な場合のみ

## CI

- GitHub ActionsでRSpec・Rubocopが自動実行される
- PRはCIがグリーンになってからレビューに出す
- テストが落ちたら自分で修正してから再プッシュする

## Git運用

### ブランチ命名
```
feature/機能名    # 新機能
fix/バグ名        # バグ修正
refactor/対象名   # リファクタリング
chore/内容        # 設定・依存関係
```

### コミットメッセージ（Conventional Commits）
```
feat(tweet): add tweet creation endpoint
fix(auth): fix session expiry handling
test(tweet): add request spec for tweet CRUD
```

### 運用ルール
- mainに直接コミットしない
- 機能単位でブランチを切る
- PRはCIグリーン後にレビューへ

## エージェント構成

| エージェント | 役割 | モデル |
|---|---|---|
| backend-developer | Model・Controller・Migration・Service | sonnet |
| frontend-developer | View・ERB・CSS・Turbo・Stimulus | sonnet |
| test-writer | RSpec・FactoryBot | sonnet |
| code-reviewer | セキュリティ・品質レビュー | opus |
| git-manager | ブランチ・コミット・PR | haiku |

### 開発フロー
```
1. git-manager   → ブランチ作成
2. backend-developer → 実装
3. frontend-developer → View実装
4. test-writer   → テスト作成・CIグリーン確認
5. code-reviewer → レビュー・指摘確認
6. git-manager   → コミット・PR作成
```

## 主要モデル

### User
- email（ユニーク・必須）
- password_digest（has_secure_password）
- username（ユニーク・必須）

### Tweet
- content（必須・140文字以内）
- user_id（外部キー）

### Like
- user_id（外部キー）
- tweet_id（外部キー）
- ユニーク制約（user_id + tweet_id）

## 機能スコープ

### 対象
- アカウント作成・ログイン・ログアウト
- 呟きの投稿・削除・一覧表示
- いいね・いいね取り消し

### 対象外（将来対応）
- 鍵アカウント
- フォロー機能
- リプライ・リツイート
- 画像投稿
