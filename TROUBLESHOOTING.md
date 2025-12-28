# 🔧 Troubleshooting Guide

## Common Issues & Solutions

### 1️⃣ MySQL Connection Issues

#### Problem: "Can't connect to MySQL"

```bash
# Solution 1: Check if MySQL is running
mysql --version
sudo systemctl status mysql

# Solution 2: Restart MySQL
sudo systemctl restart mysql
sleep 3
mysql -u root -p

# Solution 3: Check port
netstat -tuln | grep 3306
lsof -i :3306
```

#### Problem: "Access denied for user 'medexam'"

```bash
# Reset user permissions
mysql -u root -p -e "DROP USER 'medexam'@'localhost';"
mysql -u root -p -e "CREATE USER 'medexam'@'localhost' IDENTIFIED BY 'medexam';"
mysql -u root -p -e "GRANT ALL PRIVILEGES ON medexam.* TO 'medexam'@'localhost';"
mysql -u root -p -e "FLUSH PRIVILEGES;"
```

---

### 2️⃣ Database Schema Issues

#### Problem: "Schema validation failed"

```bash
# Check for syntax errors
mysql -u root -p < database/schema.sql 2>&1 | head -20

# Validate line by line
head -50 database/schema.sql | mysql -u root -p medexam

# Check for BOM (byte order mark)
file database/schema.sql
hexdump -C database/schema.sql | head

# Solution: Remove BOM if present
dos2unix database/schema.sql
# or
convert_from_utf8_bom.sh database/schema.sql
```

#### Problem: "Seed data won't load"

```bash
# Check if schema exists first
mysql -u root -p -e "SHOW TABLES IN medexam;"

# Load schema first
mysql -u root -p medexam < database/schema.sql

# Then load seed
mysql -u root -p medexam < database/seed.sql

# Check for specific errors
mysql -u root -p medexam < database/seed.sql 2>&1 | grep -i error
```

#### Problem: "Foreign key constraint fails"

```bash
# Check if parent table exists
mysql -u root -p medexam -e "SELECT * FROM specialties LIMIT 1;"

# Disable FK temporarily (debug only)
mysql -u root -p medexam -e "SET FOREIGN_KEY_CHECKS=0;"
mysql -u root -p medexam < database/seed.sql
mysql -u root -p medexam -e "SET FOREIGN_KEY_CHECKS=1;"

# Find orphaned records
mysql -u root -p medexam -e "
SELECT * FROM exam_levels el
WHERE NOT EXISTS (SELECT 1 FROM specialties s WHERE s.id=el.specialty_id);
"
```

---

### 3️⃣ Docker Issues

#### Problem: "Docker daemon not running"

```bash
# macOS
docker --version
brew services start docker

# Ubuntu
sudo systemctl status docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# Windows
# Open Docker Desktop application
```

#### Problem: "docker-compose command not found"

```bash
# Install Docker Compose
# macOS
brew install docker-compose

# Ubuntu
sudo curl -L https://github.com/docker/compose/releases/download/v2.0.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify
docker-compose --version
```

#### Problem: "MySQL container fails to start"

```bash
# Check logs
docker-compose logs mysql

# Check for port conflicts
lsof -i :3306

# Solution: Change port in docker-compose.yml
# Change "3306:3306" to "3307:3306"

# Rebuild
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

#### Problem: "phpMyAdmin can't connect to MySQL"

```bash
# Check container network
docker-compose ps
docker network ls

# Verify MySQL is accessible
docker-compose exec phpmyadmin curl http://mysql:3306

# Restart both
docker-compose restart

# Check logs
docker-compose logs phpmyadmin | tail -20
```

#### Problem: "Permission denied for docker socket"

```bash
# Solution: Add user to docker group (Linux)
sudo usermod -aG docker $USER
newgrp docker

# Test
docker ps
```

---

### 4️⃣ GitHub Actions Issues

#### Problem: "Workflow never triggers"

```bash
# Check file path
ls -la .github/workflows/main.yml

# Validate YAML syntax
python3 -m yaml < .github/workflows/main.yml
# or
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/main.yml'))"

# Force trigger with push
git add .
git commit -m "Trigger workflow"
git push origin main
```

#### Problem: "Database validation job fails"

```
Visit: GitHub repo → Actions → Latest run → database-validation
Download logs to debug
```

**Common causes:**
- Schema has SQL syntax errors
- Seed data references non-existent parent
- Character encoding issues
- File permissions

**Fix:**
1. Test locally first
2. Fix error in schema.sql/seed.sql
3. Commit and push
4. Monitor workflow

#### Problem: "Docker build job fails"

```bash
# Test locally
docker-compose build
docker-compose up -d

# Check docker-compose.yml syntax
docker-compose config

# View image layers
docker history mysql:8.0
```

#### Problem: "Insufficient disk space in CI"

```
Solution: Clean Docker resources

In your workflow file, add:
```yaml
steps:
  - name: Clean up Docker
    run: docker system prune -f
```

---

### 5️⃣ Character Encoding Issues

#### Problem: "Persian text shows as ???"

```bash
# Check database charset
mysql -u root -p medexam -e "SHOW CREATE DATABASE medexam;"

# Check table charset
mysql -u root -p medexam -e "SHOW CREATE TABLE specialties;"

# Should be: utf8mb4 / utf8mb4_unicode_ci

# Fix:
mysql -u root -p -e "ALTER DATABASE medexam CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -p medexam -e "ALTER TABLE specialties CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

#### Problem: "Emoji support missing"

```sql
-- Ensure all fields use:
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci

-- NOT just 'utf8' (which is actually utf8mb3)
```

---

### 6️⃣ File & Directory Issues

#### Problem: "File not found: database/schema.sql"

```bash
# Check current directory
pwd

# Check file exists
ls -la database/schema.sql

# Verify you're in project root
ls -la | grep docker-compose.yml

# If missing, restore from Git
git checkout database/schema.sql
```

#### Problem: ".github/workflows/main.yml" not found

```bash
# Create directory
mkdir -p .github/workflows

# Check if file exists
ls -la .github/workflows/

# If missing, restore
git checkout .github/workflows/main.yml
```

#### Problem: "Permission denied" on scripts

```bash
# Make executable
chmod +x script_name.sh

# Or for Docker
sudo chmod 666 docker-compose.yml
```

---

### 7️⃣ Performance Issues

#### Problem: "Queries are slow"

```bash
# Enable query log
mysql -u root -p medexam -e "SET GLOBAL general_log = 'ON';"

# Find slow queries
mysql -u root -p medexam -e "SHOW PROCESSLIST;"

# Check indexes
mysql -u root -p medexam -e "SHOW INDEXES FROM questions;"

# Analyze query
mysql -u root -p medexam -e "EXPLAIN SELECT * FROM questions LIMIT 10;"
```

#### Problem: "Docker container using too much memory"

```bash
# Check resource usage
docker stats

# Limit memory in docker-compose.yml
services:
  mysql:
    mem_limit: 2g
    memswap_limit: 2g
```

---

### 8️⃣ Backup & Recovery

#### Problem: "Need to restore database"

```bash
# Backup current
mysqldump -u root -p medexam > backup_$(date +%Y%m%d).sql

# Restore from file
mysql -u root -p medexam < backup.sql

# Docker backup
docker-compose exec mysql mysqldump -u medexam -pmedexam medexam > backup.sql
```

---

## 🆘 Still Having Issues?

1. **Check logs**
   ```bash
   # Docker logs
   docker-compose logs mysql
   docker-compose logs phpmyadmin
   
   # MySQL logs
   tail -100 /var/log/mysql/error.log
   ```

2. **Search existing issues**
   - GitHub Issues
   - Stack Overflow
   - MySQL documentation

3. **Create detailed issue**
   - Clear error message
   - Steps to reproduce
   - Environment details
   - Relevant logs

---

**Last Updated:** 2025-12-29
**Version:** 1.0
