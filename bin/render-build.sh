#!/usr/bin/env bash
# exit on error
set -o errexit

# 依存関係のインストール
bundle install

# アセットのプリコンパイル
bundle exec rails assets:precompile

# アセットのクリーンアップ
bundle exec rails assets:clean

# データベースのマイグレーション
bundle exec rails db:migrate