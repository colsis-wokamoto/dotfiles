# Shoei Plastic (Thailand) ウェブサイト

## 概要
- shoei-plastic.co.th 向けの企業サイト。
- 公開ページは `www/html` 配下にあり、言語別にディレクトリが分かれています。
- 主に静的な PHP/HTML + 共通インクルードで構成され、問い合わせフォームは PHPMailer で送信します。
- ローカル開発用に DB コンテナを用意していますが、現行ページでは DB を参照していません。

## 技術スタック
- PHP 8.3 + Apache（Docker）
- Composer: `phpmailer/phpmailer`, `phpstan/phpstan`（dev）
- フロント: Bootstrap, jQuery, カスタム CSS/JS
- 付随サービス: MySQL/MariaDB, phpMyAdmin, Mailpit

## 主要パス
- `www/html` 公開ルート
- `www/html/jp` 日本語ページ（デフォルト）
- `www/html/en` 英語ページ
- `www/html/jp/_12042018` 過去スナップショット
- `www/html/class/sfunction.php` メール送信と入力ヘルパー
- `www/html/.htaccess` MAIL_* / ADM_EMAIL* のデフォルト設定
- `www/yii` Yii 1.x の同梱フレームワーク（現行ページからは未使用）
- `bin/`, `config/`, `documents/`, `logs/`, `data/` は開発/運用用

## ローカル開発（Docker）
1. `docker compose up -d`
2. アクセス:
   - `http://localhost:8080`（`/jp/` へリダイレクト）
   - `http://localhost:8080/en/`
   - Mailpit UI: `http://localhost:19980`
3. 停止: `docker compose stop`

ポートや使用イメージは `.env` で変更できます。

### HTTPS（任意）
- `config/ssl` に証明書を配置し、`config/vhosts/default.conf` の 443 vhost を有効化します。

## 問い合わせフォーム / メール
- `www/html/jp/contact.php` → `contact-confirm.php`、`www/html/en/contact.php` → `contact-confirm.php`。
- 既定値は `www/html/.htaccess` にあり、`docker-compose.yml` の `mail` サービス（Mailpit）へ送信します。
- 実運用の SMTP を使う場合は、以下の環境変数を Apache 環境や `docker-compose.yml` に設定してください。

```
MAIL_USE_SMTP=true
MAIL_HOST=...
MAIL_PORT=...
MAIL_AUTH=true|false
MAIL_USERNAME=...
MAIL_PASSWORD=...
MAIL_USE_TLS=true|false
MAIL_FROM=...
MAIL_CC=...
MAIL_BCC=...
ADM_EMAIL=...
ADM_EMAIL_CT=...
ADM_EMAIL_CT_EN=...
```

## Composer / PHPStan
```
docker compose exec webserver bash -lc 'cd /var/www && composer install && ./vendor/bin/phpstan analyse --memory-limit=512M'
```

## CI/CD
- `.gitlab-ci.yml` で MR 時に PHPStan を実行し、GitLab SAST を組み込み。
- `develop` は `www/html` + `www/vendor`、`main` は加えて `www/yii` を rsync 配備。
