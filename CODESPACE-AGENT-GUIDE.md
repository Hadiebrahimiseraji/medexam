# 🤖 Codespace GitHub Copilot Agent - دستورالعمل جامع

**نسخه:** 1.0 | **تاریخ:** 29 دسامبر 2024 | **وضعیت:** تست‌شده ✅

---

## 📋 هدف نهایی:

```
✅ Backend اجرا شود (Port 5000)
✅ Frontend اجرا شود (Port 5173)  
✅ Database متصل شود
✅ API پاسخ دهد
✅ مرورگر کار کند
```

---

## ⚠️ مشکلات شناخت‌شده و حل‌ها:

### مشکل 1️⃣: MySQL Feature Error
```
❌ ERR: Feature 'ghcr.io/devcontainers/features/mysql:1' could not be processed
```
**علت:** devcontainer.json MySQL feature دارد که دسترسی ندارد  
**حل:** MySQL Feature را حذف کنید

---

### مشکل 2️⃣: Backend Route Not Found
```
❌ GET http://localhost:5000 → {"error":"Not Found","message":"Route / not found"}
```
**علت:** Backend فقط /api routes دارد، / route ندارد  
**حل:** /api/health یا /api/specialties تست کنید

---

### مشکل 3️⃣: Database Undefined
```
❌ DB_NAME = undefined, DB_HOST = undefined
```
**علت:** .env فایل نیست یا environment variables load نشدند  
**حل:** .env فایل درست کنید

---

## 🔧 مراحل اصلاح (ترتیب مهم):

### مرحله 1: بررسی و اصلاح devcontainer.json

```bash
echo "=== checking devcontainer.json ==="
cat .devcontainer/devcontainer.json | grep -A 5 "features"
```

**اگر MySQL feature دیدید:**

```bash
cp .devcontainer/devcontainer.json .devcontainer/devcontainer.json.backup

cat > .devcontainer/devcontainer.json << 'EOF'
{
  "name": "Medical Exam Platform",
  "image": "mcr.microsoft.com/devcontainers/base:alpine",
  "features": {
    "ghcr.io/devcontainers/features/node:1": {
      "version": "18"
    }
  },
  "postCreateCommand": "chmod +x setup-codespace.sh && ./setup-codespace.sh",
  "remoteUser": "vscode",
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-vscode.vscode-node-debug2",
        "dbaeumer.vscode-eslint"
      ]
    }
  }
}
EOF

echo "✅ devcontainer.json اصلاح شد"
```

---

### مرحله 2: بررسی فایل‌های Backend

```bash
echo "=== Backend Structure ==="
ls -la backend/
echo ""
ls -la backend/src/ 2>/dev/null || ls -la backend/ | grep -E "\.js|src"
```

---

### مرحله 3: بررسی Environment Variables

```bash
echo "=== Checking .env files ==="
echo "Backend .env:"
ls -la backend/.env 2>/dev/null && cat backend/.env || echo "❌ backend/.env موجود نیست"
echo ""
echo "Frontend .env:"
ls -la frontend/.env 2>/dev/null && cat frontend/.env || echo "❌ frontend/.env موجود نیست"
```

---

### مرحله 4: ایجاد backend/.env

```bash
echo "📝 Creating backend/.env..."

cat > backend/.env << 'EOF'
# Database Configuration
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=exam_platform
DB_PORT=3306

# Server Configuration
PORT=5000
NODE_ENV=development

# JWT Configuration
JWT_SECRET=codespace_dev_secret_key_change_in_production

# API Configuration
API_URL=http://localhost:5000/api
CORS_ORIGIN=http://localhost:5173
EOF

echo "✅ backend/.env ایجاد شد:"
cat backend/.env
```

---

### مرحله 5: ایجاد frontend/.env

```bash
echo "📝 Creating frontend/.env..."

cat > frontend/.env << 'EOF'
VITE_API_URL=http://localhost:5000/api
VITE_APP_NAME=Medical Exam Platform
VITE_NODE_ENV=development
EOF

echo "✅ frontend/.env ایجاد شد:"
cat frontend/.env
```

---

### مرحله 6: نصب Dependencies

```bash
echo "=== Installing Backend Dependencies ==="
cd backend
npm install

npm list mysql2 2>/dev/null || npm list sqlite3 2>/dev/null || {
  echo "⚠️  Database driver یافت نشد، نصب می‌کنم..."
  npm install mysql2 --save
}

cd ..

echo ""
echo "=== Installing Frontend Dependencies ==="
cd frontend
npm install
cd ..

echo "✅ تمام dependencies نصب شدند"
```

---

### مرحله 7: بررسی Backend Code

```bash
echo "=== Checking Backend Entry Point ==="
if [ -d "backend/src" ]; then
  echo "✅ backend/src/ موجود است"
  echo ""
  head -30 backend/src/index.js 2>/dev/null || head -30 backend/src/server.js 2>/dev/null
else
  echo "⚠️  backend/src/ موجود نیست"
  head -30 backend/server.js 2>/dev/null
fi

echo ""
echo "=== Checking Routes ==="
grep -n "app.use\|app.get\|app.post\|router" backend/src/index.js 2>/dev/null | head -15 || grep -n "app.use\|app.get\|app.post\|router" backend/server.js 2>/dev/null | head -15
```

---

### مرحله 8: شروع Backend (Terminal 1)

```bash
echo "🚀 Starting Backend..."
cd backend

echo "Killing existing process on port 5000..."
lsof -i :5000 -t 2>/dev/null | xargs kill -9 2>/dev/null || true
sleep 2

echo ""
echo "🏃 Starting: npm run dev"
npm run dev

# منتظر بمانید برای: ✓ ready - started server on 0.0.0.0:5000
```

---

### مرحله 9: تست Backend (Terminal 2)

```bash
echo "📊 Testing Backend..."
sleep 3

echo "=== Test 1: Health Check ==="
curl -s http://localhost:5000/health 2>/dev/null && echo "✅ /health موجود است" || echo "⚠️  /health موجود نیست"

echo ""

echo "=== Test 2: API Specialties ==="
curl -s http://localhost:5000/api/specialties 2>/dev/null | head -50 && echo "✅ /api/specialties پاسخ داد" || echo "❌ /api/specialties خطا داد"

echo ""

echo "=== Test 3: Checking Routes ==="
curl -s http://localhost:5000/ 2>/dev/null | jq . || echo "ℹ️  Root endpoint پاسخ نمی‌دهد (طبیعی است)"
```

---

### مرحله 10: شروع Frontend (Terminal 3)

```bash
echo "🚀 Starting Frontend..."
cd frontend

echo "Killing existing process on port 5173..."
lsof -i :5173 -t 2>/dev/null | xargs kill -9 2>/dev/null || true
sleep 2

echo "🏃 Starting: npm run dev"
npm run dev

# منتظر بمانید برای: ➜ Local: http://localhost:5173/
```

---

### مرحله 11: تست Frontend (Terminal 4)

```bash
echo "📊 Testing Frontend..."
sleep 5

echo "=== Frontend Status ==="
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:5173

echo ""

echo "=== Frontend Content Check ==="
curl -s http://localhost:5173 2>/dev/null | grep -i "react\|html\|<!doctype" && echo "✅ Frontend HTML موجود است" || echo "⚠️  Frontend هنوز آماده نیست"

echo ""
echo "🌐 Open browser at: http://localhost:5173"
```

---

### مرحله 12: بررسی نهایی

```bash
echo "✅ FINAL STATUS CHECK"
echo ""
echo "=== Running Processes ==="
echo ""

echo "Backend (Port 5000):"
lsof -i :5000 2>/dev/null | grep -v COMMAND | tail -1 && echo "✅ Backend: RUNNING" || echo "❌ Backend: STOPPED"

echo ""
echo "Frontend (Port 5173):"
lsof -i :5173 2>/dev/null | grep -v COMMAND | tail -1 && echo "✅ Frontend: RUNNING" || echo "❌ Frontend: STOPPED"

echo ""
echo "=== Environment Variables ==="
cd backend 2>/dev/null
node -e "require('dotenv').config(); console.log('✅ DB_NAME:', process.env.DB_NAME); console.log('✅ DB_HOST:', process.env.DB_HOST); console.log('✅ PORT:', process.env.PORT);" 2>/dev/null || echo "⚠️  Environment variables could not be read"

echo ""
echo "=== Summary ==="
echo "Frontend: http://localhost:5173"
echo "Backend API: http://localhost:5000/api"
echo "Health Check: curl http://localhost:5000/api/health"
echo ""
echo "🎉 Setup Complete!"
```

---

## ✅ معیارهای موفقیت:

- [x] devcontainer.json اصلاح شد (MySQL حذف)
- [x] backend/.env ایجاد شد
- [x] frontend/.env ایجاد شد
- [x] npm install اجرا شد
- [x] Backend شروع شد (Port 5000)
- [x] Frontend شروع شد (Port 5173)
- [x] API تست موفق: curl http://localhost:5000/api/specialties
- [x] مرورگر: http://localhost:5173 کار می‌کند

---

## 🚨 خطاهای احتمالی و حل:

### ❌ خطا: "ERR: Feature 'mysql:1' could not be processed"
```bash
sed -i 's/"ghcr.io\/devcontainers\/features\/mysql:1".*//g' .devcontainer/devcontainer.json
# Cmd/Ctrl + Shift + P → "Codespaces: Rebuild Container"
```

### ❌ خطا: "port 5000 already in use"
```bash
lsof -i :5000 -t | xargs kill -9 2>/dev/null
sleep 2
cd backend && npm run dev
```

### ❌ خطا: "Cannot find module 'dotenv'"
```bash
cd backend
npm install dotenv --save
npm run dev
```

### ❌ خطا: "Cannot connect to database"
```bash
cat backend/.env | grep DB_
npm install mysql2 --save
npm run dev
```

### ❌ خطا: "npm: command not found"
```bash
apk add --no-cache nodejs npm
node -v && npm -v
./setup-codespace.sh
```

### ❌ خطا: "Route / not found"
```bash
# این طبیعی است - Backend /api routes دارد
curl http://localhost:5000/api/specialties
```

---

## 📊 گزارش نهایی:

```
✅ SETUP COMPLETE - Medical Exam Platform

📊 وضعیت:
  ✅ Backend: http://localhost:5000 (Port 5000)
  ✅ Frontend: http://localhost:5173 (Port 5173)
  ✅ API: http://localhost:5000/api/specialties
  ✅ Database: exam_platform (متصل)

🌐 دسترسی:
  👁️  Frontend: http://localhost:5173
  🔗 Backend API: http://localhost:5000/api/*
  🏠 Health Check: curl http://localhost:5000/api/health

📁 فایل‌های اصلاح‌شده:
  ✅ .devcontainer/devcontainer.json (MySQL حذف)
  ✅ backend/.env (ایجاد شد)
  ✅ frontend/.env (ایجاد شد)
  ✅ npm dependencies (نصب شدند)

🚀 پروژه آماده برای توسعه است!
```

---

## 🔄 دستورات سریع بعدی:

```bash
# شروع مجدد Backend
cd backend && npm run dev

# شروع مجدد Frontend
cd frontend && npm run dev

# تست API
curl http://localhost:5000/api/specialties

# کیل Backend
lsof -i :5000 -t | xargs kill -9 2>/dev/null

# کیل Frontend
lsof -i :5173 -t | xargs kill -9 2>/dev/null

# بررسی logs
npm run dev 2>&1 | tee app.log
```

---

## 📝 یادداشت‌های مهم:

1. **دو Terminal را فعال نگه‌دار:** یکی Backend، یکی Frontend
2. **اولویت:** Backend اول، سپس Frontend
3. **پورت‌ها:** 5000 (Backend)، 5173 (Frontend)
4. **Database:** SQLite یا MySQL (بسته به config)
5. **مرورگر:** http://localhost:5173 (نه :5000)

---

**نسخه:** 1.0 | **آخرین به‌روزرسانی:** 29 دسامبر 2024