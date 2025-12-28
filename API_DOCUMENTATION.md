# 📄 MedExam API Documentation

## Base URL
```
https://api.medexam.local/v1
```

## Authentication
All endpoints require JWT token in header:
```
Authorization: Bearer <jwt_token>
```

---

## 1. Specialties & Levels

### List Specialties

**GET** `/specialties`

```bash
curl -X GET "https://api.medexam.local/v1/specialties" \
  -H "Authorization: Bearer <token>"
```

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "slug": "medicine",
      "name_fa": "پزشکی",
      "name_en": "Medicine",
      "icon": "🩺",
      "description": "تخصص پزشکی",
      "exam_levels_count": 6,
      "active_users": 1250
    },
    {
      "id": 2,
      "slug": "dentistry",
      "name_fa": "دندانپزشکی",
      "name_en": "Dentistry",
      "icon": "🦷",
      "exam_levels_count": 3
    }
  ]
}
```

---

### Get Exam Levels by Specialty

**GET** `/specialties/{specialty_slug}/levels`

```bash
curl -X GET "https://api.medexam.local/v1/specialties/medicine/levels" \
  -H "Authorization: Bearer <token>"
```

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "slug": "pre_residency",
      "name_fa": "آزمون پره",
      "name_en": "Pre-Residency Exam",
      "icon": "📚",
      "requires_subspecialty": false,
      "specialty_id": 1
    },
    {
      "id": 3,
      "slug": "board_promotion",
      "name_fa": "بورد/ارتقا",
      "name_en": "Board/Promotion",
      "icon": "📋",
      "requires_subspecialty": true,
      "subspecialties_count": 15
    }
  ]
}
```

---

### Get Subspecialties

**GET** `/specialties/{specialty_slug}/levels/{level_slug}/subspecialties`

```bash
curl -X GET "https://api.medexam.local/v1/specialties/medicine/levels/board_promotion/subspecialties" \
  -H "Authorization: Bearer <token>"
```

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "slug": "infectious",
      "name_fa": "عفونی",
      "name_en": "Infectious Diseases",
      "courses_count": 3,
      "total_exams": 45
    },
    {
      "id": 2,
      "slug": "cardiology",
      "name_fa": "قلب و عروق",
      "total_exams": 40
    }
  ]
}
```

---

## 2. Courses & Educational Content

### List Courses

**GET** `/courses`

**Query Parameters:**
```
specialty_id: integer
exam_level_id: integer
subspecialty_id: integer (optional)
```

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "slug": "harrison-infectious",
      "name_fa": "بیماری‌های عفونی - هاریسون",
      "name_en": "Infectious Diseases - Harrison",
      "chapters_count": 15,
      "total_topics": 120,
      "main_reference": "Harrison's Principles of Internal Medicine",
      "user_progress": 35
    }
  ]
}
```

---

### Get Chapters of Course

**GET** `/courses/{course_slug}/chapters`

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "slug": "bacterial-infections",
      "name_fa": "عفونت‌های باکتریال",
      "chapter_number": 1,
      "topics_count": 12,
      "estimated_study_time": 180,
      "user_progress": {
        "status": "completed",
        "completed_topics": 12,
        "total_topics": 12
      }
    }
  ]
}
```

---

### Get Topics of Chapter

**GET** `/chapters/{chapter_slug}/topics`

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "slug": "staph-aureus",
      "name_fa": "استافیلوکوکوس اورئوس",
      "estimated_study_time": 30,
      "questions_count": 15,
      "user_progress": {
        "status": "completed",
        "study_time_minutes": 35,
        "last_studied_at": "2024-12-20T10:30:00Z"
      }
    }
  ]
}
```

---

### Get Topic Content & Questions

**GET** `/topics/{topic_slug}`

**Response:**
```json
{
  "data": {
    "id": 1,
    "slug": "candidiasis",
    "name_fa": "کاندیدیازیس",
    "summary_content": "<h2>تعریف</h2>...",
    "estimated_study_time": 30,
    "questions": [
      {
        "id": 101,
        "question_text": "بیمار 45 ساله HIV+ با...",
        "question_type": "multiple_choice",
        "difficulty": "medium",
        "options": [
          {
            "id": 401,
            "option_number": 1,
            "option_text": "..."
          }
        ],
        "correct_option_id": 402,
        "explanation": {
          "explanation_text": "...",
          "references": "Harrison's Chapter 213"
        },
        "user_attempts": 2,
        "user_last_correct": true
      }
    ]
  }
}
```

---

## 3. Exams

### List Exams

**GET** `/exams`

**Query Parameters:**
```
specialty_id: integer
exam_level_id: integer
subspecialty_id: integer (optional)
exam_type: past_year | authored | combined | comprehensive
year: integer (optional)
```

**Response:**
```json
{
  "data": {
    "past_year_exams": [
      {
        "id": 1,
        "title": "آزمون ارتقا عفونی ۱۴۰۳",
        "slug": "infectious-promotion-1403",
        "exam_year": 1403,
        "exam_date": "2024-09-15",
        "total_questions": 100,
        "duration_minutes": 120,
        "passing_score": 60,
        "user_attempts": 2,
        "user_best_score": 75,
        "user_best_percentage": 75
      }
    ],
    "authored_exams": [],
    "comprehensive_exams": []
  }
}
```

---

### Start Exam

**POST** `/exams/{exam_id}/start`

**Response:**
```json
{
  "data": {
    "attempt_id": 123,
    "exam": {
      "id": 1,
      "title": "...",
      "total_questions": 100,
      "duration_minutes": 120
    },
    "questions": [
      {
        "id": 1,
        "question_text": "...",
        "options": [
          {
            "id": 401,
            "option_number": 1,
            "option_text": "..."
          }
        ],
        "question_order": 1
      }
    ],
    "started_at": "2024-12-28T10:00:00Z",
    "expires_at": "2024-12-28T12:00:00Z"
  }
}
```

---

### Submit Answer

**POST** `/attempts/{attempt_id}/answers`

**Body:**
```json
{
  "question_id": 1,
  "selected_option_id": 401
}
```

**Response:**
```json
{
  "success": true,
  "is_correct": false,
  "correct_option_id": 402
}
```

---

### Complete Exam

**POST** `/attempts/{attempt_id}/complete`

**Response:**
```json
{
  "data": {
    "attempt_id": 123,
    "score": 75,
    "percentage": 75,
    "correct_answers": 75,
    "wrong_answers": 20,
    "unanswered": 5,
    "time_spent_seconds": 5880,
    "performance_by_topic": [
      {
        "topic": "عفونت‌های باکتریال",
        "correct": 17,
        "total": 20,
        "percentage": 85
      }
    ]
  }
}
```

---

### Get Exam Results

**GET** `/attempts/{attempt_id}`

**Response:**
```json
{
  "data": {
    "attempt": {...},
    "questions_with_answers": [
      {
        "question": {...},
        "user_answer": {...},
        "is_correct": false,
        "explanation": {...}
      }
    ]
  }
}
```

---

## 4. Custom Exam Builder

### Build Custom Exam

**POST** `/exams/custom/build`

**Body:**
```json
{
  "specialty_id": 1,
  "exam_level_id": 3,
  "subspecialty_id": 1,
  "filters": {
    "source_exams": [1, 2, 3],
    "years": [1402, 1403],
    "courses": [1, 2],
    "chapters": [1, 2, 3],
    "topics": [5, 6, 7],
    "include_authored": true,
    "difficulty": ["medium", "hard"]
  },
  "questions_count": 50,
  "duration_minutes": 60
}
```

**Response:**
```json
{
  "data": {
    "exam_id": 999,
    "title": "آزمون ترکیبی سفارشی",
    "total_questions": 50,
    "ready": true
  }
}
```

---

## 5. User Progress

### Get User Progress

**GET** `/users/me/progress`

**Response:**
```json
{
  "data": {
    "primary_path": {
      "specialty": "پزشکی",
      "level": "بورد/ارتقا",
      "subspecialty": "عفونی"
    },
    "courses_progress": {
      "total_courses": 3,
      "completed": 1,
      "in_progress": 1,
      "not_started": 1
    },
    "study_stats": {
      "total_study_time_minutes": 1250,
      "topics_completed": 45,
      "topics_total": 120
    },
    "exam_stats": {
      "exams_taken": 15,
      "average_score": 72.5,
      "total_questions_answered": 1500,
      "accuracy": 72.5
    }
  }
}
```

---

### Record Study Progress

**POST** `/users/me/study-progress`

**Body:**
```json
{
  "topic_id": 1,
  "status": "completed",
  "study_time_minutes": 35
}
```

---

### Answer Topic Question

**POST** `/users/me/topic-questions/answer`

**Body:**
```json
{
  "topic_id": 1,
  "question_id": 101,
  "selected_option_id": 402
}
```

**Response:**
```json
{
  "is_correct": true,
  "correct_option_id": 402,
  "explanation": {...},
  "attempt_number": 1
}
```

---

## Error Responses

### 400 Bad Request
```json
{
  "error": "Invalid request",
  "message": "Field validation failed",
  "details": {
    "field": "questions_count",
    "message": "Must be between 1 and 200"
  }
}
```

### 401 Unauthorized
```json
{
  "error": "Unauthorized",
  "message": "Invalid or expired token"
}
```

### 404 Not Found
```json
{
  "error": "Not Found",
  "message": "Resource not found"
}
```

### 500 Server Error
```json
{
  "error": "Server Error",
  "message": "An unexpected error occurred"
}
```

---

**Last Updated:** 2025-12-29
**Version:** 1.0
