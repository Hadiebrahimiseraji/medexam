# 🎯 Codespace - دستورات نهایی خلاصه‌شده

## 📌 **یک دستور برای همه چیز:**

```bash
chmod +x setup-codespace.sh && ./setup-codespace.sh
```

✅ انتهای‌شد! پروژه‌تان آماده است.

---

## 🔄 **بعد از Setup - شروع کردن:**

### Terminal 1 (موجود):
```bash
cd backend && npm run dev
```

### Terminal 2 (جدید - Ctrl+Shift+`):
```bash
cd frontend && npm run dev
```

---

## 🌐 **باز کنید:**

- Frontend: http://localhost:5173
- Backend: http://localhost:5000
- API: http://localhost:5000/api/specialties

---

## 🛠️ **دستورات مفید:**

| کار | دستور |
|-----|--------|
| تست API | `curl http://localhost:5000/api/specialties` |
| دیدن Backend | `lsof -i :5000` |
| دیدن Frontend | `lsof -i :5173` |
| کیل Backend | `lsof -i :5000 -t \| xargs kill -9` |
| کیل Frontend | `lsof -i :5173 -t \| xargs kill -9` |
| Git status | `git status` |
| Commit | `git add . && git commit -m "msg"` |

---

## 💡 **اگر مشکل دارید:**

1. **Port in use:** `lsof -i :5000 -t | xargs kill -9`
2. **npm fail:** `npm cache clean --force && npm install`
3. **Cannot connect:** مطمئن شوید Terminal 1 و 2 هردو اجرا می‌شوند

---

## 📋 **فایل‌های مهم:**

| فایل | کاربرد |
|------|--------|
| `setup-codespace.sh` | اجرای خودکار |
| `commands.sh` | منو تعاملی |
| `QUICK-COMMANDS.md` | دستورات سریع |
| `.devcontainer/devcontainer.json` | تنظیمات Codespace |

---

## ✨ **شروع کنید:**

```bash
./setup-codespace.sh
```

**بیش از 3 دقیقه طول نمی‌کشد!** ⚡

---

**موفق باشید!** 🚀
