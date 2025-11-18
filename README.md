# 50音表アプリ (Gojuon Table)

Flutterで作成された50音表アプリです。ひらがなをタップして文字を入力できます。

## 機能

- 50音表からの文字入力
- 濁音・半濁音・拗音の選択機能
  - か行、さ行、た行、は行の濁音選択
  - き・し・ち・ひ・ふの特殊な選択メニュー
- 入力文字の表示と削除機能

## デプロイ方法

このアプリはGitHub Pagesでデプロイされます。

### 自動デプロイ（推奨）

1. GitHubのリポジトリのSettings → Pagesにアクセス
2. Sourceを「GitHub Actions」に設定
3. `main`ブランチにプッシュすると自動的にデプロイされます

### 手動デプロイ

```bash
# Webアプリをビルド
flutter build web --release --base-href "/gojuon-table/"

# gh-pagesブランチにデプロイ（オプション）
git checkout --orphan gh-pages
git add build/web -f
git commit -m "Deploy to GitHub Pages"
git push origin gh-pages --force
```

## 開発

```bash
# 依存関係のインストール
flutter pub get

# アプリの実行（Web）
flutter run -d chrome

# ビルド（Web）
flutter build web --release
```

## ライセンス

MIT License
