# Database folder

این فولدر شامل تمام فایل‌های دیتابیس پروژه است.

## فایل‌ها

- `schema.sql` : ساخت جدول‌ها و ایندکس‌ها
- `seed.sql` : داده‌های اولیه (seed)

## اجرای دستی

1) ساخت دیتابیس

```sql
CREATE DATABASE medexam CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE medexam;
```

2) اجرای schema و seed

```bash
mysql -u root -p medexam < database/schema.sql
mysql -u root -p medexam < database/seed.sql
```

## اجرای سریع با Docker

```bash
docker compose up -d
```

- MySQL روی پورت 3306
- phpMyAdmin روی http://localhost:8080

اطلاعات اتصال:
- DB: `medexam`
- User: `medexam`
- Pass: `medexam`
