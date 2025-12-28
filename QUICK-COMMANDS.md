# 🚀 دستورات سریع برای ترمینال Codespace

## 📌 نکته مهم
تمام دستورات زیر را **به‌ترتیب** در ترمینال Codespace وارد کنید.

---

## الف) Setup (یک‌بار انجام دهید)

### 1️⃣ اجرای Script خودکار (بهترین روش)

```bash
chmod +x setup-codespace.sh && ./setup-codespace.sh
```

**این script انجام می‌دهد:**
- ✅ npm را بروزرسانی می‌کند
- ✅ Backend وابستگی‌ها را نصب می‌کند
- ✅ Backend `.env` را می‌سازد
- ✅ Frontend وابستگی‌ها را نصب می‌کند
- ✅ Frontend `.env` را می‌سازد
- ✅ هر چیز را تنظیم می‌کند

**⚡ زمان: 3-5 دقیقه**

---

## ب) شروع کردن برنامه

### ✅ روش 1: Backend و Frontend جدا (راه‌بندی)

#### Terminal 1 - Backend

```bash
cd backend && npm run dev
```

**خروجی:**
```
✅ ready - started server on 0.0.0.0:5000
```

#### Terminal 2 - Frontend (Ctrl + Shift + `)

```bash
cd frontend && npm run dev
```

**خروجی:**
```
VITE v4.x.x  ready
➢  Local:   http://localhost:5173/
```

---

## ج) تست کردن

### ✅ تست Backend

```bash
curl http://localhost:5000/api/health
curl http://localhost:5000/api/specialties
```

### ✅ تست Frontend

```bash
# در مرورگر بزنید:
http://localhost:5173
```

---

## د) دستورات مفید

### 📁 نوبت دادن بین پوشه‌ها

```bash
cd /workspaces/medexam      # رفتن به root
cd backend                  # رفتن به Backend
cd frontend                 # رفتن به Frontend
cd ..                       # رفتن به بالا شنت سطح
```

### 💻 روند درحال‌اجرا

```bash
ps aux | grep node          # ممالات Node
lsof -i :5000               # Backend
lsof -i :5173               # Frontend
```

### 🛑 کیل کردن

```bash
lsof -i :5000 -t | xargs kill -9      # Backend
lsof -i :5173 -t | xargs kill -9      # Frontend
killall node                           # همه Node
```

### 📋 Git

```bash
git status                    # وضعیت
git add .                     # اضافه مؤکد ار staging
git commit -m "message"       # Commit
git push                      # Push
git pull                      # Pull
```

---

## ه) متغیرهای محیطی

### Backend `.env`

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=exam_platform
PORT=5000
JWT_SECRET=codespace_dev_secret
NODE_ENV=development
```

### Frontend `.env`

```env
VITE_API_URL=http://localhost:5000/api
```

---

## 🌟 Codespace URLs

```
Frontend: http://localhost:5173
Backend:  http://localhost:5000
API:      http://localhost:5000/api/specialties
Database: localhost:3306
```

---

## ✅ Checklist

- [ ] setup script اجرا شد
- [ ] Backend port 5000 اجرا می‌شود
- [ ] Frontend port 5173 اجرا می‌شود
- [ ] http://localhost:5000/api/health کار می‌کند
- [ ] http://localhost:5173 بارگیری می‌شود

---

**موفق باشید!** 🚀
