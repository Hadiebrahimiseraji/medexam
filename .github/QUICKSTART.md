# ⚡ MedExam - Quick Start Guide

**سریع‌ترین راه برای شروع کردن پروژه**

## ۱ - Clone راهنما

```bash
git clone https://github.com/Hadiebrahimiseraji/medexam.git
cd medexam
```

## ۲ - Docker راه (پایوسته شده)

```bash
# Docker نصب را تایید کنید
https://docs.docker.com/get-docker/

# Services را اظلاع کنید
docker-compose up -d

# بررسی کنید
docker-compose ps
```

**عبور به:**
- MySQL: `localhost:3306`
- phpMyAdmin: `http://localhost:8080`
- User: `medexam` | Pass: `medexam`

## ۳ - MySQL مستقیم (بدون Docker)

```bash
# 1. MySQL را نصب عمل آورید
mysql -u root -p -e "CREATE DATABASE medexam CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 2. Schema را load کنید
mysql -u root -p medexam < database/schema.sql

# 3. Seed داتا را load کنید
mysql -u root -p medexam < database/seed.sql

# 4. بررسی کنید
mysql -u root -p medexam -e "SHOW TABLES;"
```

## ۴ - GitHub Actions بررسی

```
1. https://github.com/Hadiebrahimiseraji/medexam
2. "Actions" را مربوط کلیک کنید
3. آخرین workflow run را آنجا ببینید
4. هر job را بررسی کنید
```

## ۵ - سطوح بعدی

- [📂 Setup Guide](./.github/SETUP.md)
- [🚀 Workflow Docs](./.github/workflows/README.md)
- [📛 Database Docs](./database/README.md)

---

**نعملکرد باشد ✅**
