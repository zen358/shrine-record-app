# CLAUDE.md

このファイルは、Claude Code がこのリポジトリで継続開発を行う際のガイドラインです。

## プロジェクト概要

「参拝記録アプリ（shrine-record-app）」— 参拝した神社の記録を保存・閲覧する個人向け Web アプリ。

現在実装済みの中核機能:
- ユーザー登録・ログイン（Devise）
- 参拝記録（`ShrineRecord`）の作成・閲覧・編集・削除（CRUD）
  - 神社名、参拝日、御祭神、御利益、お願いごと、メモ、緯度経度、写真を記録
- プロフィール表示・編集（`resource :profile`）
- 写真添付（Active Storage、`has_one_attached :photo`）

将来的な拡張予定（未実装、方向性として尊重すること）:
- 写真の複数枚対応・ギャラリー表示
- 家族などとの記録共有
- 神社情報（御祭神・由緒などのマスタデータ）
- 参拝イベント・記念日管理
- 思い出保存（アルバム的な機能）

拡張を進める際は、上記の将来像と矛盾しない設計を優先しつつ、現時点で不要な抽象化は行わないこと（YAGNI）。

## 現在の技術構成

- Ruby 3.3.6
- Ruby on Rails 7.1.6
- PostgreSQL
- Docker / Docker Compose（`compose.yml`, `Dockerfile`, `Dockerfile.dev`）
- Devise（認証）
- Active Storage（写真添付）
- Bootstrap 5（`bootstrap-icons` 含む）
- Hotwire（Turbo Rails / Stimulus）
- jsbundling-rails + esbuild（JS ビルド）
- cssbundling-rails + sass + postcss/autoprefixer（CSS ビルド）
- propshaft（アセットパイプライン）
- GitHub（リモート: `zen358/shrine-record-app`）

テストは Minitest（`test/` ディレクトリ）。system テスト用に Capybara / Selenium も導入済みだが、現状カバレッジは薄い。

## 開発環境

- Windows 上で VS Code を使用
- 開発は Docker 前提（`docker compose up` 等）。ホスト側に Ruby / PostgreSQL / Yarn が入っていない前提で助言・コマンド提案を行うこと
- 作業は常にリポジトリのルートディレクトリを基準に行う
- OS固有の絶対パスには依存しない
- Windows / macOS のどちらでも動作する前提でコマンドや設定を提案する
- パス区切りや改行コードなど、OS差異に注意する
- 改行コード:
  - `.gitattributes` で `bin/*` と `*.sh` は `text eol=lf` に固定されている
  - これらのファイルを編集する際は LF 改行を必ず維持すること（CRLF に変換しない）
  - `.gitattributes` の設定内容を変更する場合は、その影響を事前に説明すること
- コンテナ構成:
  - `db` サービス: PostgreSQL（ポート 5432、ヘルスチェックあり）
  - `web` サービス: Rails アプリ（`Dockerfile.dev` でビルド、`bin/dev` で起動、ポート 3000）

## 開発ルール

- 既存コードを必ず確認してから変更する（推測で書き始めない）
- いきなり大規模変更をしない。1機能ずつ小さく実装する
- 変更前に、何をどう変更するか影響範囲を説明する
- DB変更（マイグレーション）を行う際は、内容（テーブル・カラム・型・制約など）を事前に説明してから実行する
- gem を安易に追加しない。追加が必要な場合は理由と代替案の有無を説明したうえで提案する
- 既存の Rails MVC 構成を崩さない
- Devise による既存の認証の仕組みを尊重する（独自の認証ロジックを勝手に追加しない）
- 「他ユーザーの参拝記録にアクセスできない」設計を必ず維持する
  - 例: `ShrineRecordsController` は `current_user.shrine_records` 経由でのみレコードを取得している。新規実装・改修でもこのパターンを踏襲し、`ShrineRecord.find` のような全件アクセスは行わない
- 写真関連の機能は Active Storage を使用する（別ライブラリを持ち込まない）
- 本番ストレージ設定は未完了（`config/storage.yml` はローカル `Disk` サービスのみで S3 等は未設定）。関連する作業は GitHub Issue #25 を前提に進める
- テストが少ないため、重要な機能追加・修正時はテスト追加を検討する（Minitest / Capybara）
- Bootstrap 5 / Hotwire（Turbo・Stimulus）の既存構成を優先し、別の UI フレームワークや独自の JS 基盤を持ち込まない

## Git / GitHub 運用

- 作業開始前に `git status` で現在の状態を確認する
- 関連する GitHub Issue が既にないか確認してから作業を始める
- 変更は小さくまとめる（1コミット・1PRの範囲を絞る）
- コミットメッセージは変更内容が分かるように書く
- 原則として `main` ブランチへ直接 push しない
- 機能追加・修正は必要に応じて作業ブランチを作成する
- `main` へ直接 push する場合は、必ず事前にユーザーへ確認する

## Claude Code への指示

- 作業開始前に、何を変更するか簡潔に説明する
- コード変更後は、変更箇所とその理由を説明する
- 可能な範囲で動作確認・テストを実施する（Docker 環境上での実行を前提とする）
- エラーが発生した場合は原因を調査してから対応する。推測だけで修正しない
- 既存の設計思想（上記「開発ルール」参照）と GitHub Issue の文脈を優先する
- 仕様や設計判断について不明点がある場合は、勝手に決めずユーザーに確認する

## 安全ルール

- `git commit`、`git push`、`git merge`、Pull Request作成は、ユーザーから明示的な指示がある場合のみ実行する
- `main` ブランチへ直接 push しない。必要な場合は事前にユーザーへ確認する
- `rails db:drop`、`db:reset`、大量データ削除、migration rollback など、データを失う可能性がある操作は事前確認なしに実行しない
- 本番環境のDB・ストレージ・Render等の設定を変更する場合は、必ず変更内容と影響を説明し、ユーザーの承認を得てから実施する
- `config/master.key`、credentials、APIキー、パスワード、SMTP認証情報、AWS/S3等の秘密情報をGitにコミットしない
- `.env` 等の秘密情報を含むファイルを作成する場合は、`.gitignore` の対象であることを確認する
- 不明なファイルや設定を「不要そう」という理由だけで削除しない
- Rails / gem / Nodeパッケージのバージョンアップは、影響範囲を説明してから実施する

## 作業完了時の確認

変更後は可能な範囲で以下を確認すること。

1. `git diff` で意図しない変更がないこと
2. 関連するテストが通ること
3. Railsアプリが正常に起動すること
4. 既存機能を壊していないこと
5. 新たな警告・エラーが発生していないこと

作業完了時は、
- 変更したファイル
- 変更内容
- 実施したテスト
- 未確認事項
- 次に推奨する作業

をユーザーに報告すること。
