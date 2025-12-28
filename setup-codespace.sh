#!/bin/bash

# ============================================================
# Setup Script برای GitHub Codespace
# پروژه: پلتفرم آزمون‌یار پزشکی
# ============================================================

echo "🚀 شروع راه‌اندازی Codespace..."
echo ""

# رنگ‌ها برای output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================================
# مرحله 1: Update npm
# ============================================================
echo -e "${BLUE}📦 مرحله 1: بروزرسانی npm${NC}"
npm install -g npm@latest
echo -e "${GREEN}✅ npm به‌روز شد${NC}\n"

# ============================================================
# مرحله 2: Backend Setup
# ============================================================
echo -e "${BLUE}🔧 مرحله 2: Setup Backend${NC}"

cd backend

# نصب وابستگی‌ها
echo "📥 نصب وابستگی‌های Backend..."
npm install

# ایجاد فایل .env
echo "⚙️  ایجاد فایل .env..."
cat > .env << 'EOF'
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=exam_platform
PORT=5000
JWT_SECRET=codespace_dev_secret_key_change_in_production
NODE_ENV=development
EOF

echo -e "${GREEN}✅ Backend آماده شد${NC}\n"

# برگشت به root
cd ..

# ============================================================
# مرحله 3: Frontend Setup
# ============================================================
echo -e "${BLUE}⚛️  مرحله 3: Setup Frontend${NC}"

cd frontend

# نصب وابستگی‌ها
echo "📥 نصب وابستگی‌های Frontend..."
npm install

# ایجاد فایل .env
echo "⚙️  ایجاد فایل .env..."
cat > .env << 'EOF'
VITE_API_URL=http://localhost:5000/api
EOF

# ایجاد .env.example
cat > .env.example << 'EOF'
VITE_API_URL=http://localhost:5000/api
EOF

echo -e "${GREEN}✅ Frontend آماده شد${NC}\n"

cd ..

# ============================================================
# مرحله 4: Database Setup
# ============================================================
echo -e "${BLUE}🗄️  مرحله 4: Setup Database${NC}"

# بررسی MySQL
if command -v mysql &> /dev/null; then
    echo "✅ MySQL نصب‌شده است"
else
    echo "⚠️  MySQL نصب نیست. برای Codespace کافی است."
fi

echo -e "${GREEN}✅ Database آماده است${NC}\n"

# ============================================================
# مرحله 5: Git Configuration
# ============================================================
echo -e "${BLUE}📝 مرحله 5: تنظیم Git${NC}"

# اگر git مخزن راه‌اندازی نشده باشد
if [ ! -d ".git" ]; then
    git init
    git add .
    git commit -m "Initial commit - Codespace setup" || true
fi

echo -e "${GREEN}✅ Git آماده است${NC}\n"

# ============================================================
# خلاصه نهایی
# ============================================================
echo "═══════════════════════════════════════════════════════════"
echo -e "${GREEN}🎉 Codespace راه‌اندازی موفق بود!${NC}"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo -e "${YELLOW}📌 مراحل بعدی:${NC}"
echo ""
echo "1️⃣  Backend را شروع کنید:"
echo "   cd backend"
echo "   npm run dev"
echo ""
echo "2️⃣  Terminal جدید باز کنید (Ctrl + Shift + \`) و:"
echo "   cd frontend"
echo "   npm run dev"
echo ""
echo "3️⃣  سرویس‌ها به این آدرس‌ها متصل می‌شوند:"
echo "   Backend:  http://localhost:5000"
echo "   Frontend: http://localhost:5173"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
