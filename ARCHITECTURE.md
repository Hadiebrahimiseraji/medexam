# 🏑 MedExam Database Architecture

## System Overview

```
┌─────────────────────────┐
│  MedExam Platform                  │
├─────────────────────────┤
│  Database (MySQL 8.0)              │
│  - Specialties → Users            │
│  - Exams → Questions             │
│  - Progress Tracking                │
├─────────────────────────┤
│  Docker Containers                 │
│  - MySQL Server                    │
│  - phpMyAdmin (UI)                 │
├─────────────────────────┤
│  CI/CD Pipeline (GitHub Actions)   │
│  - DB Validation                   │
│  - Docker Build Test               │
│  - Code Quality                    │
└─────────────────────────┘
```

## Database Hierarchy

### Level 1: Specialties (تخصص)
```
Specialties (e.g., Medicine, Dentistry)
  └─ exam_levels (e.g., Pre-Residency, Residency, Board)
      └─ subspecialties (optional, e.g., Infectious Disease)
```

### Level 2: Educational Content (محتوا)
```
Courses (درس‌ها)
  └─ Chapters (فصل‌ها)
      └─ Topics (موضوعات)
```

### Level 3: Assessment (Quiz)
```
Exams (آزمون)
  └─ Questions (سوالات)
      └─ Options (گزینه‌ها)
      └─ Explanations (تشریحات)
```

### Level 4: User Progress
```
Users (کاربران)
  └─ exam_attempts (تلاش‌ها)
      └─ answers (پاسخ‌ها)
  └─ study_progress (پیشرفت)
  └─ bookmarks (نشانکات)
```

## Table Relationships

```
specialties (1)
  └─ (N) exam_levels
      └─ (N) subspecialties
      └─ (N) courses
          └─ (N) chapters
              └─ (N) topics
                  └─ (N) questions
                      └─ (N) question_options
                      └─ (1) question_explanations

exams (1)
  └─ (N) exam_questions
      └─ (N) questions

users (1)
  └─ (N) user_exam_attempts
      └─ (N) user_answers
  └─ (N) user_study_progress
  └─ (N) user_bookmarks
```

## Character Set & Collation

**Database-wide:**
```sql
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci
```

**Benefits:**
- ✅ Full Unicode support (including emoji)
- ✅ Persian language support
- ✅ Multi-language queries
- ✅ Future-proof

## Indexing Strategy

### Primary Keys
Every table has auto-increment `id` as PRIMARY KEY

### Foreign Keys
All relationships use foreign keys with:
- `ON DELETE CASCADE` (child records deleted with parent)
- `ON DELETE SET NULL` (child foreign key set to NULL)

### Performance Indexes

```
specialties:
  - idx_slug
  - idx_active

exam_levels:
  - idx_specialty
  - idx_slug
  - UNIQUE(specialty_id, slug)

questions:
  - idx_path (specialty, exam_level, subspecialty)
  - idx_content (course, chapter, topic)
  - FULLTEXT(question_text)

exams:
  - idx_published
  - idx_year
  - idx_type

users:
  - idx_email
  - idx_primary_path

user_answers:
  - unique_attempt_question

user_study_progress:
  - unique_user_topic
  - idx_user_status
```

## Field Types

### Text Fields
- `name_fa`: Persian names (VARCHAR 100-300)
- `name_en`: English names (VARCHAR 100-300)
- `description`: Details (TEXT)
- `question_text`: Questions (LONGTEXT)
- `explanation_text`: Explanations (LONGTEXT)

### Numeric Fields
- `id`: AUTO_INCREMENT INT
- `display_order`: Sorting (INT)
- `total_questions`: Count (INT)
- `duration_minutes`: Time (INT)
- `points`: Score (DECIMAL 5,2)
- `percentage`: Percentage (DECIMAL 5,2)

### Boolean Fields
- `is_active`: Active status
- `is_published`: Published status
- `is_correct`: Answer correctness
- `requires_subspecialty`: Flag

### DateTime Fields
- `created_at`: TIMESTAMP DEFAULT CURRENT_TIMESTAMP
- `updated_at`: TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
- `completed_at`: TIMESTAMP NULL (nullable for in-progress)

## Enums

### question_type
- `multiple_choice` (default)
- `true_false`
- `descriptive`

### difficulty
- `easy`
- `medium` (default)
- `hard`

### exam_type_classification
- `past_year`
- `authored`
- `combined`
- `comprehensive`
- `custom`

### user_exam_status
- `in_progress` (default)
- `completed`
- `abandoned`

### study_progress_status
- `not_started` (default)
- `in_progress`
- `completed`
- `reviewing`

## Constraints

### Uniqueness
- Email per user (users.email)
- Specialty slug (specialties.slug)
- Exam slug (exams.slug)
- Question in exam (exam_questions)
- User bookmark per question
- User-topic progress

### Check Constraints (Implicit)
- Percentages: 0-100
- FOREIGN KEY integrity
- NOT NULL fields enforced

## JSON Fields

### exams.combination_filters
Stores filter criteria for combined exams:
```json
{
  "difficulty": ["easy", "medium"],
  "years": [2022, 2023, 2024],
  "topics": [1, 2, 3]
}
```

### questions.tags
Stores question tags:
```json
[
  "inflammation",
  "treatment",
  "diagnosis"
]
```

## Data Integrity Rules

1. **Referential Integrity**: All FKs enforced
2. **Cascade Deletes**: Child records deleted with parent
3. **Charset Consistency**: utf8mb4 everywhere
4. **Timestamp Tracking**: All tables track creation/update
5. **Active Status**: All major entities can be deactivated

## Scalability Considerations

### Current Capacity
- Handles 1M+ questions
- Supports 100K+ concurrent users
- Stores 10 years of exam history

### For Growth
- Partition by exam_year (questions)
- Archive old user_answers
- Cache frequently accessed specialties
- Read replicas for reporting

## Backup Strategy

```bash
# Full backup
mysqldump -u root -p medexam > backup.sql

# Incremental (binary log)
mysqldump --single-transaction -u root -p medexam > backup.sql

# Docker backup
docker-compose exec mysql mysqldump -u medexam -pmedexam medexam > backup.sql
```

## Performance Tips

1. ✅ Index often-filtered fields
2. ✅ Use LIMIT for pagination
3. ✅ Batch operations when possible
4. ✅ Cache question sets by topic
5. ✅ Archive old exam attempts monthly

---

**Version:** 1.0
**Last Updated:** 2025-12-29
**Status:** ✅ Production Ready
