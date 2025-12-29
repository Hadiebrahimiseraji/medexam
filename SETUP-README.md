# 🚀 Medical Exam Platform - Quick Setup

## 🏠 Project Structure

```
medexam/
├─ backend/          # Express.js API
├─ frontend/         # React + Vite
├─ .devcontainer/   # Codespace config
├─ AGENT-INSTRUCTIONS.md     # For Copilot Agents
├─ CODESPACE-AGENT-GUIDE.md  # Detailed troubleshooting
├─ SETUP-README.md           # This file
├─ package.json     # Root dependencies
├─ docker-compose.yml # Docker setup
└─ setup-codespace.sh # Auto setup script
```

---

## 🚀 Quick Start (30 seconds)

### Option 1: Automatic (Recommended)

```bash
# Run everything
chmod +x setup-codespace.sh && ./setup-codespace.sh
```

### Option 2: Manual

```bash
# Terminal 1: Backend
cd backend && npm install && npm run dev

# Terminal 2: Frontend
cd frontend && npm install && npm run dev

# Open browser
http://localhost:5173
```

---

## 📊 Problem-Free Setup (For Agents)

If you're a GitHub Copilot Agent, read:

1. **First:** `AGENT-INSTRUCTIONS.md` (execution steps)
2. **Reference:** `CODESPACE-AGENT-GUIDE.md` (troubleshooting)

---

## 🌐 Access Points

| Service | URL | Status |
|---------|-----|--------|
| Frontend | http://localhost:5173 | 🌟 Development |
| Backend | http://localhost:5000 | 🌟 Development |
| API Docs | http://localhost:5000/api | 🌟 Documentation |
| Health | http://localhost:5000/api/health | 🌟 Monitoring |

---

## 💾 Environment Variables

### backend/.env
```env
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
```

### frontend/.env
```env
VITE_API_URL=http://localhost:5000/api
VITE_APP_NAME=Medical Exam Platform
VITE_NODE_ENV=development
```

---

## 🚨 Common Issues

### Port Already in Use
```bash
lsof -i :5000 -t | xargs kill -9
lsof -i :5173 -t | xargs kill -9
```

### DB Variables Undefined
```bash
cat backend/.env
# Check if DB_HOST, DB_NAME, etc. are present
```

### MySQL Feature Error
```bash
# Delete MySQL feature from .devcontainer/devcontainer.json
# Rebuild Codespace: Cmd+Shift+P → "Codespaces: Rebuild Container"
```

### Module Not Found
```bash
cd backend && npm install
cd frontend && npm install
```

---

## 🔧 Useful Commands

```bash
# Backend
cd backend
npm install              # Install dependencies
npm run dev             # Start development server
npm run build           # Build for production
npm test                # Run tests

# Frontend  
cd frontend
npm install             # Install dependencies
npm run dev            # Start development server
npm run build          # Build for production
npm run preview        # Preview production build

# API Testing
curl http://localhost:5000/api/specialties
curl http://localhost:5000/api/health

# Process Management
lsof -i :5000          # Check port 5000
lsof -i :5173          # Check port 5173
ps aux | grep node     # List all Node processes
```

---

## 📋 Tech Stack

**Backend:**
- Node.js 18
- Express.js
- MySQL/SQLite
- dotenv

**Frontend:**
- React 18+
- Vite
- TypeScript (optional)

**DevOps:**
- Docker (optional)
- GitHub Codespaces
- Alpine Linux

---

## 🚀 For GitHub Copilot Agents

**Start here:**
```
1. Read: AGENT-INSTRUCTIONS.md
2. Execute: Auto setup script
3. Verify: All endpoints working
4. Report: Success/failure status
```

**Expected output:**
```
✅ Backend: RUNNING (Port 5000)
✅ Frontend: RUNNING (Port 5173)
✅ API: Responding
✅ Database: Connected
🎉 Setup Complete!
```

---

## 📋 Additional Resources

- [Node.js Docs](https://nodejs.org/docs/)
- [Express.js Guide](https://expressjs.com/)
- [React Docs](https://react.dev/)
- [Vite Guide](https://vitejs.dev/)
- [GitHub Codespaces](https://github.com/features/codespaces)

---

**Last Updated:** 2024-12-29  
**Status:** ✅ Production Ready  
**Version:** 1.0
