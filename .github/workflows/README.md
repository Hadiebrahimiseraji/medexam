# 🚀 GitHub Actions CI/CD Pipeline - MedExam

## نمای کلی

این workflow یک pipeline جامع برای تایید کیفیت پروژه MedExam فراهم می‌کند.

## 📋 Jobs (وظایف)

### 1️⃣ **Database Validation**
بررسی صحت دیتابیس و داده‌های Seed

**مراحل:**
- ✅ اجرای MySQL container
- ✅ تایید syntax فایل `schema.sql`
- ✅ بارگذاری داده‌های Seed
- ✅ تایید وجود تمام جدول‌های اصلی
- ✅ بررسی سلامت داده‌ها (orphaned records)

**بروز خطا در این مرحله:**
```
❌ schema.sql یا seed.sql دارای خطای SQL است
❌ جدولی از جدول‌های اساسی ایجاد نشده است
❌ داده‌های Seed بارگذاری نشده است
```

---

### 2️⃣ **Docker Build Validation**
بررسی صحت Docker images و stack

**مراحل:**
- ✅ تایید صحت `docker-compose.yml`
- ✅ Build MySQL image
- ✅ Build phpMyAdmin image
- ✅ Test اجرای مجموعه (stack startup)
- ✅ بررسی اتصال database

**بروز خطا:**
```
❌ docker-compose.yml دارای خطا است
❌ MySQL container شروع نمی‌شود
❌ phpMyAdmin container ساخت نمی‌شود
```

---

### 3️⃣ **Code Quality & Security**
بررسی کیفیت کد و مسائل امنیتی

**مراحل:**
- ✅ تایید syntax YAML files
- ✅ تایید syntax SQL files
- ✅ جستجو برای credentials hardcoded
- ✅ بررسی ریسک SQL injection
- ✅ تایید charset consistency (utf8mb4)
- ✅ تایید Persian language support

**هشدار‌ها:**
```
⚠️ Hardcoded credentials found
⚠️ Dynamic SQL patterns detected
⚠️ Mixed charset definitions
```

---

### 4️⃣ **File Structure Validation**
بررسی ساختار فایل‌های پروژه

**الزامات:**
```
✅ README.md
✅ docker-compose.yml
✅ database/schema.sql
✅ database/seed.sql
✅ database/init.sql
✅ database/README.md
```

**بروز خطا:**
```
❌ فایل اساسی موجود نیست
❌ فایل‌های database خالی یا کمتر از حد انتظار هستند
```

---

### 5️⃣ **Build Summary**
خلاصه نتایج تمام jobs

**نمایش:**
- 📊 وضعیت هر job
- ⏰ زمان اجرا
- 📄 گزارش خلاصه

**عملکرد نهایی:**
اگر تمام jobs موفق باشند → ✅ **PASS**
اگر هر یک ناموفق باشد → ❌ **FAIL**

---

### 6️⃣ **Documentation**
بررسی کیفیت documentation

**بررسی‌ها:**
- ✅ وجود README.md
- ✅ وجود database/README.md
- ✅ تعداد خطوط documentation
- ✅ وجود بخش‌های ضروری

---

## ⏰ زمان اجرا

workflow در این زمان‌ها اجرا می‌شود:

| وقت | تفصیل |
|------|--------|
| **هر push** | به `main` یا `develop` |
| **هر PR** | به `main` یا `develop` |
| **روزانه ساعت 2 AM UTC** | security checks |
| **دستی** | از Actions tab |

---

## 🔍 مراقبت‌های خودکار

### Trigger بر اساس فایل‌ها (Optional)
اگر بخواهید workflow فقط برای تغییرات خاص اجرا شود:

```yaml
on:
  push:
    branches: [main]
    paths:
      - 'database/**'
      - 'docker-compose.yml'
      - '.github/workflows/**'
```

---

## 📊 Artifacts

هر اجرا نتایج زیر را save می‌کند:

```
📁 database-validation-report/
  ├─ schema_output.log
  └─ seed_output.log

📁 build-report/
  └─ build_report.md
```

**دانلود:**
پس از اجرا workflow → Actions tab → آخرین run → Artifacts

---

## ✅ Passing Criteria

تمام موارد زیر باید موفق باشند:

- [ ] Database validation ✔
- [ ] Docker build ✔
- [ ] Code quality ✔
- [ ] File structure ✔
- [ ] Documentation ✔

---

## ❌ Troubleshooting

### مشکل: "Schema validation failed"
```bash
# بررسی محلی
mysql -u root -proot -e "SOURCE database/schema.sql" medexam_test
```

### مشکل: "Docker build failed"
```bash
# تست محلی
docker-compose build
docker-compose up -d
```

### مشکل: "MySQL not ready"
```bash
# بررسی وضعیت
docker-compose ps
docker-compose logs mysql
```

---

## 🔐 Security Notes

1. ✅ هیچ credential در SQL files نیست
2. ✅ Environment variables برای passwords استفاده می‌شوند
3. ✅ Charset صحیح برای Persian text
4. ✅ Foreign key constraints فعال هستند

---

## 📈 بهینه‌سازی

برای کاهش زمان اجرا:
- [ ] Cache Docker images
- [ ] Parallel jobs (احتیاج ندارد)
- [ ] Skip unnecessary checks

---

## 🛠️ سفارشی‌سازی

### اضافه کردن Job جدید

```yaml
  my-new-job:
    name: My Custom Check
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      - run: echo "Custom check"
```

### تغییر Schedule

```yaml
schedule:
  - cron: '0 */6 * * *'  # ساعت 6 ساعت یکبار
```

---

## 📞 مراجع

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Docker Compose Reference](https://docs.github.com/en/actions/using-containerized-services/about-service-containers)
- [MySQL Testing](https://dev.mysql.com/)

---

**اخرین بروزرسانی:** 2025-12-29
**نسخه:** 1.0
