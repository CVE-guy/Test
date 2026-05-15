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

## アーキテクチャ方針

- Skinny Controller・Fat Modelは避ける
- ビジネスロジックが複雑になる場合はapp/services/に切り出す
- ScopeはModelに定義する
- N+1は必ずincludes/preloadで対処する
- Strong Parametersは必ず明示する

## ディレクトリ構成

- コントローラー → app/controllers/
- モデル → app/models/
- サービス → app/services/（必要な場合のみ）
- ビュー → app/views/（APIではなくHTML）

## コーディング規約

- Rubocopの設定に従う
- メソッドは短く、1つのことだけやる
- マジックナンバーは定数化する

## テスト方針

- RSpecで記述する
- describe/context/itの3層構造を守る
- テストデータはFactoryBotで作成する（直接DBに書かない）
- 正常系・異常系・境界値をカバーする
- Controllerテストはrequest specで書く

## CI

- GitHub ActionsでRSpec・Rubocopが自動実行される
- PRはCIがグリーンになってからレビューに出す
- テストが落ちたら自分で修正してから再プッシュする

## 主要モデル

- User（アカウント）
- Tweet（呟き）
- Like（いいね）

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

