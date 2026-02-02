# Shoei Plastic (Thailand) Website

## Overview
- Corporate website for shoei-plastic.co.th.
- Public pages live under `www/html`, split into language directories.
- Mostly static PHP/HTML with shared includes; the contact form sends email via PHPMailer.
- A database container is provided for local stacks, but the current site pages do not use it.

## Tech Stack
- PHP 8.3 + Apache (Docker)
- Composer: `phpmailer/phpmailer`, `phpstan/phpstan` (dev)
- Frontend: Bootstrap, jQuery, custom CSS/JS
- Optional services: MySQL/MariaDB, phpMyAdmin, Mailpit

## Key Paths
- `www/html` public document root
- `www/html/jp` Japanese pages (default entry)
- `www/html/en` English pages
- `www/html/jp/_12042018` legacy snapshot
- `www/html/class/sfunction.php` mail + input helpers
- `www/html/.htaccess` environment defaults (MAIL_*, ADM_EMAIL*)
- `www/yii` vendored Yii 1.x framework (not referenced by current pages)
- `bin/`, `config/`, `documents/`, `logs/`, `data/` support local dev and ops

## Local Development (Docker)
1. `docker compose up -d`
2. Open:
   - `http://localhost:8080` (redirects to `/jp/`)
   - `http://localhost:8080/en/`
   - Mailpit UI: `http://localhost:19980`
3. Stop: `docker compose stop`

Ports and images are configurable in `.env`.

### HTTPS (optional)
- Put certs in `config/ssl` and uncomment the 443 vhost in `config/vhosts/default.conf`.

## Contact Form / Mail
- Forms: `www/html/jp/contact.php` -> `contact-confirm.php`, `www/html/en/contact.php` -> `contact-confirm.php`.
- Mail settings default to `www/html/.htaccess` and point to the `mail` service in `docker-compose.yml`.
- For real SMTP, set these environment variables (in Apache envs or `docker-compose.yml`):

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
- `.gitlab-ci.yml` runs PHPStan on merge requests and includes GitLab SAST.
- Deploy jobs rsync `www/html` + `www/vendor` on `develop`, and also `www/yii` on `main`.
