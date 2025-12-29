# 🤖 Agent - دستورالعمل اجرایی

**نتیجه موردانتظار:** پروژه درحال اجرا و آماده برای توسعه

---

## 📊 خلاصه مسئله:

پروژه Medical Exam Platform دارای مشکلات زیر است:
1. ❌ MySQL Feature در devcontainer.json بسته اجرا را متوقف می‌کند
2. ❌ فایل‌های .env موجود نیستند
3. ❌ Database variables undefined هستند
4. ❌ Backend و Frontend اجرا نمی‌شوند

---

## ✅ هدف Agent:

**خودکار کردن این مراحل:**
```
✅ اصلاح devcontainer.json
✅ ایجاد .env فایل‌ها
✅ نصب تمام dependencies
✅ اجرای Backend (Port 5000)
✅ اجرای Frontend (Port 5173)
✅ تست API endpoints
✅ تأیید موفقیت
```

---

## 🚀 روش اجرا:

### **گزینه 1: اجرای خودکار کامل (بهترین)**

Agent این دستورات را بیایی‌یکی پس از دیگری اجرا کند:

```bash
#!/bin/bash
set -e

echo "🚀 Medical Exam Platform - Auto Setup"
echo "=========================================="
echo ""

# مرحله 1: اصلاح devcontainer.json
echo "🔧 مرحله 1: اصلاح devcontainer.json"
cp .devcontainer/devcontainer.json .devcontainer/devcontainer.json.backup 2>/dev/null || true
cat > .devcontainer/devcontainer.json << 'EOF'
{
  "name": "Medical Exam Platform",
  "image": "mcr.microsoft.com/devcontainers/base:alpine",
  "features": {
    "ghcr.io/devcontainers/features/node:1": {"version": "18"}
  },
  "postCreateCommand": "chmod +x setup-codespace.sh && ./setup-codespace.sh",
  "remoteUser": "vscode",
  "customizations": {"vscode": {"extensions": ["ms-vscode.vscode-node-debug2", "dbaeumer.vscode-eslint"]}}
}
EOF
echo "✅ devcontainer.json اصلاح شد"
echo ""

# مرحله 2: ایجاد backend/.env
echo "🔧 مرحله 2: ایجاد backend/.env"
cat > backend/.env << 'EOF'
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=exam_platform
DB_PORT=3306
PORT=5000
NODE_ENV=development
JWT_SECRET=codespace_dev_secret_key_change_in_production
API_URL=http://localhost:5000/api
CORS_ORIGIN=http://localhost:5173
EOF
echo "✅ backend/.env ایجاد شد"
echo ""

# مرحله 3: ایجاد frontend/.env
echo "🔧 مرحله 3: ایجاد frontend/.env"
cat > frontend/.env << 'EOF'
VITE_API_URL=http://localhost:5000/api
VITE_APP_NAME=Medical Exam Platform
VITE_NODE_ENV=development
EOF
echo "✅ frontend/.env ایجاد شد"
echo ""

# مرحله 4: نصب Backend Dependencies
echo "🔧 مرحله 4: نصب Backend Dependencies"
cd backend
npm install --silent

if ! npm list mysql2 2>/dev/null | grep -q mysql2; then
  echo "نصب mysql2..."
  npm install mysql2 --save --silent
fi
cd ..
echo "✅ Backend dependencies نصب شد"
echo ""

# مرحله 5: نصب Frontend Dependencies
echo "🔧 مرحله 5: نصب Frontend Dependencies"
cd frontend
npm install --silent
cd ..
echo "✅ Frontend dependencies نصب شد"
echo ""

# مرحله 6: کیل کردن پروسس‌های قدیمی
echo "🔧 مرحله 6: پاکسازی پورت‌ها"
lsof -i :5000 -t 2>/dev/null | xargs kill -9 2>/dev/null || true
lsof -i :5173 -t 2>/dev/null | xargs kill -9 2>/dev/null || true
sleep 2
echo "✅ پورت‌ها پاکسازی شدند"
echo ""

# مرحله 7: اجرای Backend (در پس‌زمینه)
echo "🔧 مرحله 7: اجرای Backend"
cd backend
npm run dev > backend.log 2>&1 &
BACKEND_PID=$!
echo "Backend PID: $BACKEND_PID"
cd ..
sleep 3
echo "✅ Backend شروع شد"
echo ""

# مرحله 8: تست Backend
echo "🔧 مرحله 8: تست Backend"
echo "تست API..."
if curl -s http://localhost:5000/api/specialties 2>/dev/null | grep -q '\['; then
  echo "✅ Backend پاسخ می‌دهد!"
else
  echo "⚠️  Backend هنوز آماده نیست (30 ثانیه صبر کنید)"
  sleep 5
fi
echo ""

# مرحله 9: اجرای Frontend (در پس‌زمینه)
echo "🔧 مرحله 9: اجرای Frontend"
cd frontend
npm run dev > frontend.log 2>&1 &
FRONTEND_PID=$!
echo "Frontend PID: $FRONTEND_PID"
cd ..
sleep 5
echo "✅ Frontend شروع شد"
echo ""

# مرحله 10: بررسی نهایی
echo "🔧 مرحله 10: بررسی نهایی"
echo ""
echo "=== FINAL STATUS ==="
echo ""

if lsof -i :5000 2>/dev/null | grep -q node; then
  echo "✅ Backend: RUNNING (Port 5000)"
else
  echo "❌ Backend: STOPPED"
fi

if lsof -i :5173 2>/dev/null | grep -q node; then
  echo "✅ Frontend: RUNNING (Port 5173)"
else
  echo "❌ Frontend: STOPPED"
fi

echo ""
echo "=== URLS ==="
echo "🌐 Frontend: http://localhost:5173"
echo "🔗 Backend API: http://localhost:5000/api"
echo "📋 Health Check: curl http://localhost:5000/api/health"
echo "💾 API Test: curl http://localhost:5000/api/specialties"
echo ""
echo "🎉 Setup Complete!"
echo ""
echo "لاگ‌های Backend: tail -f backend/backend.log"
echo "لاگ‌های Frontend: tail -f frontend/frontend.log"
```

---

### **گزینه 2: اجرای تدریجی (برای Debugging)**

اگر نیاز به مراحل جداگانه است:

#### مرحله 1:
```bash
cp .devcontainer/devcontainer.json .devcontainer/devcontainer.json.backup
cat > .devcontainer/devcontainer.json << 'EOF'
{"name": "Medical Exam Platform", "image": "mcr.microsoft.com/devcontainers/base:alpine", "features": {"ghcr.io/devcontainers/features/node:1": {"version": "18"}}, "postCreateCommand": "chmod +x setup-codespace.sh && ./setup-codespace.sh", "remoteUser": "vscode"}
EOF
```

#### مرحله 2:
```bash
cat > backend/.env << 'EOF'
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=exam_platform
DB_PORT=3306
PORT=5000
NODE_ENV=development
JWT_SECRET=codespace_dev_secret_key_change_in_production
EOF
```

#### مرحله 3:
```bash
cat > frontend/.env << 'EOF'
VITE_API_URL=http://localhost:5000/api
VITE_APP_NAME=Medical Exam Platform
VITE_NODE_ENV=development
EOF
```

#### مرحله 4:
```bash
cd backend && npm install && npm install mysql2 --save && cd ..
cd frontend && npm install && cd ..
```

#### مرحله 5 (Terminal 1):
```bash
cd backend && npm run dev
```

#### مرحله 6 (Terminal 2):
```bash
cd frontend && npm run dev
```

---

## 🚨 خطاهای متوقع و حل:

### خطا: "ERR: Feature 'mysql:1' could not be processed"
**حل:** devcontainer.json را دوباره بررسی کنید و MySQL feature را حذف کنید

### خطا: "Cannot find module 'dotenv'"
**حل:** 
```bash
cd backend && npm install dotenv --save
```

### خطا: "Port 5000 already in use"
**حل:**
```bash
lsof -i :5000 -t | xargs kill -9
sleep 2
npm run dev
```

### خطا: "DB_NAME undefined"
**حل:** بررسی کنید backend/.env موجود است و DB_NAME را دارد
```bash
cat backend/.env | grep DB_NAME
```

---

## 📊 معیارهای موفقیت:

```
✅ devcontainer.json اصلاح شد (MySQL حذف)
✅ backend/.env ایجاد شد
✅ frontend/.env ایجاد شد
✅ npm install اجرا شد
✅ Backend شروع شد (Port 5000)
✅ Frontend شروع شد (Port 5173)
✅ curl http://localhost:5000/api/specialties پاسخ داد
✅ http://localhost:5173 در مرورگر کار می‌کند
```

---

## 📝 یادداشت‌های مهم برای Agent:

1. **تمام مراحل باید پی‌درپی اجرا شوند**
2. **منتظر باشید بین مراحل (sleep 2-5 ثانیه)**
3. **خروجی لاگ‌ها را بررسی کنید**
4. **اگر خطا رخ داد، توقف کنید و گزارش دهید**
5. **فایل‌های log را برای debugging ذخیره کنید**

---

## 📋 آخرین گام برای Agent:

بعد از اتمام موفق:

```
🌟 Setup Complete! Medical Exam Platform
👁️  Frontend: http://localhost:5173
🔗 Backend API: http://localhost:5000/api/specialties
🚀 Project is ready for development!
```
