-- ==========================================================
-- DATABASE SCHEMA: MedExam Platform
-- Charset: utf8mb4 (full Persian/Unicode support)
-- Engine: InnoDB (FK support)
-- ==========================================================

SET FOREIGN_KEY_CHECKS=0;

-- ==========================================================
-- LEVEL 1: specialties (پزشکی/دندانپزشکی)
-- ==========================================================
CREATE TABLE IF NOT EXISTS specialties (
    id INT PRIMARY KEY AUTO_INCREMENT,
    slug VARCHAR(50) UNIQUE NOT NULL,
    name_fa VARCHAR(100) NOT NULL,
    name_en VARCHAR(100),
    icon VARCHAR(50),
    description TEXT,
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_slug (slug),
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='تخصص‌های اصلی';

-- ==========================================================
-- LEVEL 2: exam_levels (پره/دستیاری/بورد/…)
-- ==========================================================
CREATE TABLE IF NOT EXISTS exam_levels (
    id INT PRIMARY KEY AUTO_INCREMENT,
    specialty_id INT NOT NULL,
    slug VARCHAR(50) NOT NULL,
    name_fa VARCHAR(100) NOT NULL,
    name_en VARCHAR(100),
    description TEXT,
    icon VARCHAR(50),

    requires_subspecialty BOOLEAN DEFAULT FALSE,

    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (specialty_id) REFERENCES specialties(id) ON DELETE CASCADE,
    UNIQUE KEY unique_level (specialty_id, slug),
    INDEX idx_specialty (specialty_id),
    INDEX idx_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='سطح/نوع آزمون';

-- ==========================================================
-- LEVEL 3: subspecialties (فقط در مسیرهایی که لازم دارند)
-- ==========================================================
CREATE TABLE IF NOT EXISTS subspecialties (
    id INT PRIMARY KEY AUTO_INCREMENT,
    specialty_id INT NOT NULL,
    exam_level_id INT NOT NULL,
    slug VARCHAR(50) NOT NULL,
    name_fa VARCHAR(100) NOT NULL,
    name_en VARCHAR(100),
    description TEXT,
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (specialty_id) REFERENCES specialties(id) ON DELETE CASCADE,
    FOREIGN KEY (exam_level_id) REFERENCES exam_levels(id) ON DELETE CASCADE,
    UNIQUE KEY unique_subspecialty (specialty_id, exam_level_id, slug),
    INDEX idx_specialty_level (specialty_id, exam_level_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='تخصص‌های فرعی';

-- ==========================================================
-- COURSES / CHAPTERS / TOPICS (درسنامه)
-- ==========================================================
CREATE TABLE IF NOT EXISTS courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    specialty_id INT NOT NULL,
    exam_level_id INT NOT NULL,
    subspecialty_id INT NULL,

    slug VARCHAR(100) NOT NULL,
    name_fa VARCHAR(200) NOT NULL,
    name_en VARCHAR(200),
    description TEXT,

    main_reference VARCHAR(300),
    author VARCHAR(200),

    display_order INT DEFAULT 0,

    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (specialty_id) REFERENCES specialties(id),
    FOREIGN KEY (exam_level_id) REFERENCES exam_levels(id),
    FOREIGN KEY (subspecialty_id) REFERENCES subspecialties(id) ON DELETE CASCADE,

    UNIQUE KEY unique_course (specialty_id, exam_level_id, subspecialty_id, slug),
    INDEX idx_path (specialty_id, exam_level_id, subspecialty_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='درس‌ها';

CREATE TABLE IF NOT EXISTS chapters (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,

    slug VARCHAR(100) NOT NULL,
    name_fa VARCHAR(300) NOT NULL,
    name_en VARCHAR(300),
    description TEXT,

    chapter_number INT,
    estimated_study_time INT COMMENT 'دقیقه',

    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY unique_chapter (course_id, slug),
    INDEX idx_course (course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='فصل‌ها';

CREATE TABLE IF NOT EXISTS topics (
    id INT PRIMARY KEY AUTO_INCREMENT,
    chapter_id INT NOT NULL,

    slug VARCHAR(100) NOT NULL,
    name_fa VARCHAR(300) NOT NULL,
    name_en VARCHAR(300),

    summary_content LONGTEXT COMMENT 'جزوه خلاصه (Markdown/HTML)',
    estimated_study_time INT COMMENT 'دقیقه',

    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (chapter_id) REFERENCES chapters(id) ON DELETE CASCADE,
    UNIQUE KEY unique_topic (chapter_id, slug),
    INDEX idx_chapter (chapter_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='موضوعات';

-- ==========================================================
-- EXAMS / QUESTIONS
-- ==========================================================
CREATE TABLE IF NOT EXISTS exam_types_classification (
    id INT PRIMARY KEY AUTO_INCREMENT,
    slug VARCHAR(50) UNIQUE NOT NULL,
    name_fa VARCHAR(100) NOT NULL,
    description TEXT,
    display_order INT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='دسته‌بندی آزمون';

CREATE TABLE IF NOT EXISTS exams (
    id INT PRIMARY KEY AUTO_INCREMENT,

    specialty_id INT NOT NULL,
    exam_level_id INT NOT NULL,
    subspecialty_id INT NULL,

    exam_type_classification_id INT NOT NULL,

    title VARCHAR(300) NOT NULL,
    slug VARCHAR(150) UNIQUE NOT NULL,
    description TEXT,

    exam_year INT NULL,
    exam_date DATE NULL,

    total_questions INT NOT NULL DEFAULT 0,
    duration_minutes INT,
    passing_score DECIMAL(5,2),

    is_comprehensive BOOLEAN DEFAULT FALSE,
    is_combined BOOLEAN DEFAULT FALSE,
    combination_filters JSON NULL,

    is_active BOOLEAN DEFAULT TRUE,
    is_published BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (specialty_id) REFERENCES specialties(id),
    FOREIGN KEY (exam_level_id) REFERENCES exam_levels(id),
    FOREIGN KEY (subspecialty_id) REFERENCES subspecialties(id) ON DELETE CASCADE,
    FOREIGN KEY (exam_type_classification_id) REFERENCES exam_types_classification(id),

    INDEX idx_path (specialty_id, exam_level_id, subspecialty_id),
    INDEX idx_type (exam_type_classification_id),
    INDEX idx_year (exam_year),
    INDEX idx_published (is_published)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='آزمون‌ها';

CREATE TABLE IF NOT EXISTS questions (
    id INT PRIMARY KEY AUTO_INCREMENT,

    specialty_id INT NOT NULL,
    exam_level_id INT NOT NULL,
    subspecialty_id INT NULL,

    course_id INT NULL,
    chapter_id INT NULL,
    topic_id INT NULL,

    question_text LONGTEXT NOT NULL,
    question_html LONGTEXT,

    image_url VARCHAR(500),
    has_image BOOLEAN DEFAULT FALSE,

    question_type ENUM('multiple_choice', 'true_false', 'descriptive') DEFAULT 'multiple_choice',
    difficulty ENUM('easy', 'medium', 'hard') DEFAULT 'medium',

    tags JSON,

    source VARCHAR(300),
    source_year INT,
    source_exam_id INT NULL,

    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (specialty_id) REFERENCES specialties(id),
    FOREIGN KEY (exam_level_id) REFERENCES exam_levels(id),
    FOREIGN KEY (subspecialty_id) REFERENCES subspecialties(id) ON DELETE SET NULL,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE SET NULL,
    FOREIGN KEY (chapter_id) REFERENCES chapters(id) ON DELETE SET NULL,
    FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE SET NULL,
    FOREIGN KEY (source_exam_id) REFERENCES exams(id) ON DELETE SET NULL,

    INDEX idx_path (specialty_id, exam_level_id, subspecialty_id),
    INDEX idx_content (course_id, chapter_id, topic_id),
    INDEX idx_source (source_exam_id),
    FULLTEXT idx_question_text (question_text)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='سوالات';

CREATE TABLE IF NOT EXISTS question_options (
    id INT PRIMARY KEY AUTO_INCREMENT,
    question_id INT NOT NULL,

    option_number INT NOT NULL,
    option_text TEXT NOT NULL,
    option_html TEXT,

    is_correct BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,
    UNIQUE KEY unique_option (question_id, option_number),
    INDEX idx_question (question_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='گزینه‌های سوال';

CREATE TABLE IF NOT EXISTS question_explanations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    question_id INT NOT NULL UNIQUE,

    explanation_text LONGTEXT NOT NULL,
    explanation_html LONGTEXT,

    references TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='پاسخ تشریحی';

CREATE TABLE IF NOT EXISTS exam_questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    exam_id INT NOT NULL,
    question_id INT NOT NULL,

    question_order INT NOT NULL,
    points DECIMAL(5,2) DEFAULT 1.00,

    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,

    UNIQUE KEY unique_exam_question (exam_id, question_id),
    INDEX idx_exam_order (exam_id, question_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='سوالات هر آزمون';

-- ==========================================================
-- USERS + PROGRESS
-- ==========================================================
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,

    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),

    primary_specialty_id INT,
    primary_exam_level_id INT,
    primary_subspecialty_id INT NULL,

    is_email_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (primary_specialty_id) REFERENCES specialties(id) ON DELETE SET NULL,
    FOREIGN KEY (primary_exam_level_id) REFERENCES exam_levels(id) ON DELETE SET NULL,
    FOREIGN KEY (primary_subspecialty_id) REFERENCES subspecialties(id) ON DELETE SET NULL,

    INDEX idx_email (email),
    INDEX idx_primary_path (primary_specialty_id, primary_exam_level_id, primary_subspecialty_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='کاربران';

CREATE TABLE IF NOT EXISTS user_exam_attempts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    exam_id INT NOT NULL,

    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,

    status ENUM('in_progress', 'completed', 'abandoned') DEFAULT 'in_progress',

    total_questions INT,
    correct_answers INT DEFAULT 0,
    wrong_answers INT DEFAULT 0,
    unanswered INT DEFAULT 0,

    score DECIMAL(5,2),
    percentage DECIMAL(5,2),
    time_spent_seconds INT,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE,

    INDEX idx_user_exam (user_id, exam_id),
    INDEX idx_status (status),
    INDEX idx_completed (completed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='تلاش آزمون';

CREATE TABLE IF NOT EXISTS user_answers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    attempt_id INT NOT NULL,
    question_id INT NOT NULL,

    selected_option_id INT NULL,
    is_correct BOOLEAN,

    time_spent_seconds INT,
    answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (attempt_id) REFERENCES user_exam_attempts(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,
    FOREIGN KEY (selected_option_id) REFERENCES question_options(id) ON DELETE SET NULL,

    UNIQUE KEY unique_attempt_question (attempt_id, question_id),
    INDEX idx_attempt (attempt_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='پاسخ کاربر';

CREATE TABLE IF NOT EXISTS user_bookmarks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    question_id INT NOT NULL,

    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,

    UNIQUE KEY unique_user_bookmark (user_id, question_id),
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='نشانک سوال';

CREATE TABLE IF NOT EXISTS user_study_progress (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    topic_id INT NOT NULL,

    status ENUM('not_started', 'in_progress', 'completed', 'reviewing') DEFAULT 'not_started',
    completion_percentage INT DEFAULT 0,
    study_time_minutes INT DEFAULT 0,

    last_studied_at TIMESTAMP NULL,
    completed_at TIMESTAMP NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE CASCADE,

    UNIQUE KEY unique_user_topic (user_id, topic_id),
    INDEX idx_user_status (user_id, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='پیشرفت مطالعه';

CREATE TABLE IF NOT EXISTS user_topic_question_attempts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    topic_id INT NOT NULL,
    question_id INT NOT NULL,

    selected_option_id INT NULL,
    is_correct BOOLEAN,

    attempt_number INT DEFAULT 1,
    answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,
    FOREIGN KEY (selected_option_id) REFERENCES question_options(id) ON DELETE SET NULL,

    INDEX idx_user_topic (user_id, topic_id),
    INDEX idx_answered (answered_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='تلاش سوال موضوعی';

SET FOREIGN_KEY_CHECKS=1;
