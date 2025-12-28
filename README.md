# medexam

پروژه در حال ساخت.

## دیتابیس

برای ساخت دیتابیس و جداول MySQL از فولدر `database/` استفاده کنید:

- `database/schema.sql` : ساخت همه جداول
- `database/seed.sql` : داده‌های اولیه (Specialty/Level/Subspecialty/…)
- `database/init.sql` : اسکریپت یکپارچه برای Docker (ساخت DB + schema + seed)

### سریع‌ترین روش (Docker)

```bash
docker compose up -d
```

سپس دیتابیس `medexam` با کاربر `medexam` و پسورد `medexam` آماده است.

### روش دستی (بدون Docker)

```sql
CREATE DATABASE medexam CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE medexam;
SOURCE database/schema.sql;
SOURCE database/seed.sql;
```
