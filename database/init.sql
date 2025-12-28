-- ==========================================================
-- init.sql (Docker entrypoint)
-- This script is executed automatically by MySQL container.
-- ==========================================================

CREATE DATABASE IF NOT EXISTS medexam CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE medexam;

-- ========== schema ==========
SOURCE /docker-entrypoint-initdb.d/schema.sql;

-- ========== seed ==========
SOURCE /docker-entrypoint-initdb.d/seed.sql;
