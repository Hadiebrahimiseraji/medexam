# 🚀 MedExam - Complete Setup & CI/CD Guide

## فهرست مطالب

- [1. Requirements](#1--requirements)
- [2. Local Setup](#2--local-setup)
- [3. Docker Setup](#3--docker-setup)
- [4. GitHub Actions](#4--github-actions)
- [5. Verification Checklist](#5--verification-checklist)
- [6. Troubleshooting](#6--troubleshooting)

---

## 1. 📂 Requirements

### برای یک سرور Linux/Unix

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y mysql-server mysql-client docker.io docker-compose git

# macOS (with Homebrew)
brew install mysql docker-compose git

# Windows (with WSL2)
wsl --install
apt-get install mysql-server mysql-client docker.io docker-compose git
```

### نسخه‌ها

| نرم افزار | نسخه | لنک |
|-------------|--------|------|
| MySQL | 8.0+ | [mysql.com](https://dev.mysql.com/) |
| Docker | 20.10+ | [docker.com](https://docs.docker.com/install/) |
| Docker Compose | 2.0+ | [docker docs](https://docs.docker.com/compose/install/) |
| Git | 2.30+ | [git-scm.com](https://git-scm.com/) |
| GitHub CLI (Optional) | Latest | [cli.github.com](https://cli.github.com/) |

---

## 2. 💻 Local Setup

### Step 1: Clone Repository

```bash
git clone https://github.com/Hadiebrahimiseraji/medexam.git
cd medexam
git branch -a
```

### Step 2: Manual Database Setup (Without Docker)

#### 2.1 Start MySQL Server

```bash
# macOS
brew services start mysql

# Ubuntu/Linux
sudo systemctl start mysql

# Windows (WSL2)
sudo service mysql start
```

#### 2.2 Create Database

```bash
mysql -u root -p -e "CREATE DATABASE medexam CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

#### 2.3 Load Schema

```bash
mysql -u root -p medexam < database/schema.sql
```

#### 2.4 Load Seed Data

```bash
mysql -u root -p medexam < database/seed.sql
```

#### 2.5 Verify Installation

```bash
mysql -u root -p medexam -e "SHOW TABLES;"
mysql -u root -p medexam -e "SELECT COUNT(*) AS specialty_count FROM specialties;"
```

### Step 3: Connect & Test

```bash
# Test with specific user
mysql -h 127.0.0.1 -u medexam -pmedexam medexam

# In MySQL prompt
mysql> SHOW TABLES;
mysql> SELECT * FROM specialties LIMIT 5;
mysql> exit;
```

---

## 3. 🐛 Docker Setup

### Option A: Full Stack (Recommended for Development)

```bash
# Step 1: Clone & navigate
git clone https://github.com/Hadiebrahimiseraji/medexam.git
cd medexam

# Step 2: Build images
docker-compose build

# Step 3: Start services
docker-compose up -d

# Step 4: Wait for MySQL readiness (10-15 seconds)
sleep 15

# Step 5: Verify
docker-compose ps
```

### Check Services

```bash
# MySQL status
docker-compose exec mysql mysqladmin ping -u medexam -pmedexam

# MySQL prompt
docker-compose exec mysql mysql -u medexam -pmedexam medexam -e "SHOW TABLES;"

# phpMyAdmin (open in browser)
# http://localhost:8080
# User: medexam
# Password: medexam
```

### Option B: Manual Docker Commands

```bash
# MySQL only
docker run -d \
  --name medexam-mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=medexam \
  -e MYSQL_USER=medexam \
  -e MYSQL_PASSWORD=medexam \
  -p 3306:3306 \
  mysql:8.0

# Wait & load schema
sleep 20
docker exec medexam-mysql mysql -u root -proot medexam < database/schema.sql
docker exec medexam-mysql mysql -u root -proot medexam < database/seed.sql
```

### Stop & Cleanup

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: Data loss)
docker-compose down -v

# Stop specific container
docker-compose stop mysql
```

---

## 4. 🚀 GitHub Actions

### Workflow File Location

```
.github/workflows/main.yml
```

### Automatic Triggers

ورکفلو به طور خودکار در این موارد اجرا می‌شود:

1. **Push to Main/Develop**
   ```bash
   git push origin main
   # Workflow triggers automatically
   ```

2. **Create Pull Request**
   ```bash
   # GitHub automatically runs checks before merge
   ```

3. **Schedule (Daily)**
   ```
   Every day at 2 AM UTC (security checks)
   ```

4. **Manual Trigger**
   ```
   GitHub Actions tab → main.yml → Run workflow
   ```

### View Workflow Status

#### Method 1: GitHub Web Interface
```
1. Go to: https://github.com/Hadiebrahimiseraji/medexam
2. Click "Actions" tab
3. Select latest workflow run
4. View each job status
```

#### Method 2: GitHub CLI
```bash
# Install GitHub CLI (if not installed)
brew install gh  # macOS
sudo apt-get install gh  # Ubuntu

# Login
gh auth login

# View latest workflow
gh run list -R Hadiebrahimiseraji/medexam
gh run view <run-id> -R Hadiebrahimiseraji/medexam
```

#### Method 3: Watch in Real-time
```bash
# Using gh CLI with watch
gh run list -R Hadiebrahimiseraji/medexam --limit 1
```

### What Each Job Does

#### Job 1: Database Validation
```
✓ Starts MySQL container
✓ Validates schema.sql syntax
✓ Loads seed.sql data
✓ Verifies all tables exist
✓ Checks data integrity
✓ Detects orphaned records
```

#### Job 2: Docker Build
```
✓ Validates docker-compose.yml
✓ Builds MySQL image
✓ Builds phpMyAdmin image
✓ Tests stack startup
✓ Verifies database connection
```

#### Job 3: Code Quality
```
✓ Validates YAML syntax
✓ Validates SQL syntax
✓ Checks for hardcoded credentials
✓ Detects SQL injection risks
✓ Verifies charset consistency
✓ Checks Persian language support
```

#### Job 4: File Structure
```
✓ Verifies required files exist
✓ Checks file sizes
✓ Validates directory structure
```

#### Job 5: Build Summary
```
✓ Generates report of all jobs
✓ Creates summary artifacts
✓ Final pass/fail decision
```

#### Job 6: Documentation
```
✓ Checks README completeness
✓ Verifies database documentation
✓ Scans for broken links
```

### Artifacts (Download Results)

هر اجرا artifacts نیز save می‌کند:

```
Actions → [Latest Run] → Artifacts
├── database-validation-report/
│   ├── schema_output.log
│   └── seed_output.log
└── build-report/
    └── build_report.md
```

### Workflow Customization

#### Change Branch Triggers
```yaml
on:
  push:
    branches:
      - main
      - develop
      - staging  # Add new branch
```

#### Change Schedule
```yaml
schedule:
  - cron: '0 2 * * *'  # Daily at 2 AM UTC
  # Other examples:
  # - cron: '0 */6 * * *'   # Every 6 hours
  # - cron: '0 9 * * MON'   # Every Monday at 9 AM
```

#### Add Environment Variables
```yaml
jobs:
  database-validation:
    env:
      MYSQL_ROOT_PASSWORD: ${{ secrets.DB_ROOT_PASS }}
      MYSQL_USER: ${{ secrets.DB_USER }}
```

---

## 5. ✅ Verification Checklist

اینجا تمام موارد برای بررسی هستند:

### فایل‌ها

- [ ] `README.md` موجود است
- [ ] `docker-compose.yml` موجود است
- [ ] `database/schema.sql` موجود است
- [ ] `database/seed.sql` موجود است
- [ ] `database/init.sql` موجود است
- [ ] `database/README.md` موجود است
- [ ] `.github/workflows/main.yml` موجود است
- [ ] `.github/workflows/README.md` موجود است

### Database (Local)

- [ ] MySQL 8.0+ نصب شده است
- [ ] Database `medexam` ایجاد شد
- [ ] Schema load شد بدون خطا
- [ ] Seed data load شد بدون خطا
- [ ] Minimum 2 specialties موجود است
- [ ] Minimum 5 exam levels موجود است
- [ ] Foreign keys درست کار می‌کند

### Docker

- [ ] Docker 20.10+ نصب شده است
- [ ] Docker Compose 2.0+ نصب شده است
- [ ] `docker-compose build` موفق است
- [ ] `docker-compose up -d` موفق است
- [ ] MySQL container سالم است
- [ ] phpMyAdmin accessible است (localhost:8080)
- [ ] Database user `medexam` کار می‌کند

### GitHub Actions

- [ ] `.github/workflows/main.yml` صحیح است
- [ ] Workflow triggers on push
- [ ] Workflow triggers on PR
- [ ] Database validation job passes
- [ ] Docker build job passes
- [ ] Code quality job passes
- [ ] File structure job passes
- [ ] All artifacts generated شد

### Final Status

- [ ] Green checkmark ✅ در GitHub Actions
- [ ] تمام logs قابل درک هستند
- [ ] No error messages

---

## 6. 🐛 Troubleshooting

### مشکل 1: MySQL Connection Error

**خطا:**
```
Error: connect ECONNREFUSED 127.0.0.1:3306
```

**راه‌حل:**
```bash
# Check if MySQL is running
mysql --version
sudo systemctl status mysql

# Restart MySQL
sudo systemctl restart mysql
sleep 5

# Test connection
mysql -u root -p
```

### مشکل 2: Schema Validation Failed

**خطا:**
```
Error 1064: SQL syntax error
```

**راه‌حل:**
```bash
# Test schema locally
mysql -u root -p test_db < database/schema.sql

# Check for character encoding
file database/schema.sql

# Check for BOM
hexdump -C database/schema.sql | head
```

### مشکل 3: Docker Build Failed

**خطا:**
```
error checking context: can't stat
```

**راه‌حل:**
```bash
# Ensure in correct directory
pwd
ls -la docker-compose.yml

# Clean and rebuild
docker-compose down -v
docker-compose build --no-cache
```

### مشکل 4: Workflow Never Triggers

**مشکل:** GitHub Actions tab خالی است

**راه‌حل:**
```bash
# Verify file path
ls -la .github/workflows/main.yml

# Check YAML syntax
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/main.yml'))"

# Force trigger with push
git add .
git commit -m "Trigger workflow"
git push origin main
```

### مشکل 5: Database User Permissions

**خطا:**
```
Access denied for user 'medexam'@'localhost'
```

**راه‌حل:**
```bash
# Reset with root
mysql -u root -p -e "DROP USER 'medexam'@'localhost';"
mysql -u root -p -e "CREATE USER 'medexam'@'localhost' IDENTIFIED BY 'medexam';"
mysql -u root -p -e "GRANT ALL PRIVILEGES ON medexam.* TO 'medexam'@'localhost';"
mysql -u root -p -e "FLUSH PRIVILEGES;"
```

### مشکل 6: phpMyAdmin Not Accessible

**خطا:**
```
Connection refused at localhost:8080
```

**راه‌حل:**
```bash
# Check container logs
docker-compose logs phpmyadmin

# Check port binding
docker-compose ps

# Try different port
# Edit docker-compose.yml and change 8080 to 8081
```

---

## 📚 اسناد مرتبط

1. [Database Schema](database/README.md)
2. [Workflow Documentation](.github/workflows/README.md)
3. [Main README](../README.md)

---

## 🐦‍♂️ نکات مهم

✅ **بهترین تمرینات:**
- Always test locally before pushing
- Keep database backups
- Use version control for schema changes
- Monitor GitHub Actions logs

⚠️ **احتیاطات:**
- Don't commit production passwords
- Use environment variables for secrets
- Test schema changes on backup database
- Keep MySQL and Docker updated

---

**آپدیت:**  2025-12-29
**نسخه:** 1.0
**وضعیت:** ✅ مکمل
