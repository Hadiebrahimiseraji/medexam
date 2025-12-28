-- ==========================================================
-- SEED DATA (Initial Data)
-- NOTE: IDs are NOT hardcoded; all FK refs use subqueries.
-- ==========================================================

-- ----------------------
-- Specialties
-- ----------------------
INSERT IGNORE INTO specialties (slug, name_fa, name_en, icon, display_order) VALUES
('medicine', 'پزشکی', 'Medicine', '🩺', 1),
('dentistry', 'دندانپزشکی', 'Dentistry', '🦷', 2);

-- ----------------------
-- Exam Levels (Medicine)
-- ----------------------
INSERT IGNORE INTO exam_levels (specialty_id, slug, name_fa, name_en, icon, requires_subspecialty, display_order)
SELECT s.id, 'pre_residency', 'آزمون پره', 'Pre-Residency Exam', '📚', FALSE, 1
FROM specialties s WHERE s.slug='medicine';

INSERT IGNORE INTO exam_levels (specialty_id, slug, name_fa, name_en, icon, requires_subspecialty, display_order)
SELECT s.id, 'residency', 'آزمون دستیاری', 'Residency Exam', '🎓', FALSE, 2
FROM specialties s WHERE s.slug='medicine';

INSERT IGNORE INTO exam_levels (specialty_id, slug, name_fa, name_en, icon, requires_subspecialty, display_order)
SELECT s.id, 'board_promotion', 'بورد/ارتقا', 'Board/Promotion', '📊', TRUE, 3
FROM specialties s WHERE s.slug='medicine';

INSERT IGNORE INTO exam_levels (specialty_id, slug, name_fa, name_en, icon, requires_subspecialty, display_order)
SELECT s.id, 'national', 'آزمون ملی', 'National Exam', '🏆', FALSE, 4
FROM specialties s WHERE s.slug='medicine';

INSERT IGNORE INTO exam_levels (specialty_id, slug, name_fa, name_en, icon, requires_subspecialty, display_order)
SELECT s.id, 'qualification', 'آزمون صلاحیت', 'Qualification Exam', '✅', FALSE, 5
FROM specialties s WHERE s.slug='medicine';

INSERT IGNORE INTO exam_levels (specialty_id, slug, name_fa, name_en, icon, requires_subspecialty, display_order)
SELECT s.id, 'bachelor_to_md', 'لیسانس به پزشکی', 'Bachelor to MD', '🎯', FALSE, 6
FROM specialties s WHERE s.slug='medicine';

-- ----------------------
-- Exam Levels (Dentistry)
-- ----------------------
INSERT IGNORE INTO exam_levels (specialty_id, slug, name_fa, name_en, icon, requires_subspecialty, display_order)
SELECT s.id, 'residency', 'دستیاری دندانپزشکی', 'Dental Residency', '🎓', FALSE, 1
FROM specialties s WHERE s.slug='dentistry';

INSERT IGNORE INTO exam_levels (specialty_id, slug, name_fa, name_en, icon, requires_subspecialty, display_order)
SELECT s.id, 'board_promotion', 'بورد/ارتقا دندانپزشکی', 'Dental Board/Promotion', '📊', TRUE, 2
FROM specialties s WHERE s.slug='dentistry';

INSERT IGNORE INTO exam_levels (specialty_id, slug, name_fa, name_en, icon, requires_subspecialty, display_order)
SELECT s.id, 'national', 'آزمون ملی دندانپزشکی', 'National Dental Exam', '🏆', FALSE, 3
FROM specialties s WHERE s.slug='dentistry';

-- ----------------------
-- Subspecialties (Medicine / board_promotion)
-- ----------------------
INSERT IGNORE INTO subspecialties (specialty_id, exam_level_id, slug, name_fa, name_en, display_order)
SELECT
  s.id,
  l.id,
  v.slug,
  v.name_fa,
  v.name_en,
  v.display_order
FROM specialties s
JOIN exam_levels l ON l.specialty_id=s.id AND l.slug='board_promotion'
JOIN (
  SELECT 'infectious' AS slug, 'عفونی' AS name_fa, 'Infectious Diseases' AS name_en, 1 AS display_order UNION ALL
  SELECT 'cardiology', 'قلب و عروق', 'Cardiology', 2 UNION ALL
  SELECT 'gastroenterology', 'گوارش', 'Gastroenterology', 3 UNION ALL
  SELECT 'pulmonology', 'ریه', 'Pulmonology', 4 UNION ALL
  SELECT 'nephrology', 'کلیه', 'Nephrology', 5 UNION ALL
  SELECT 'endocrinology', 'غدد', 'Endocrinology', 6 UNION ALL
  SELECT 'hematology', 'خون', 'Hematology', 7 UNION ALL
  SELECT 'rheumatology', 'روماتولوژی', 'Rheumatology', 8 UNION ALL
  SELECT 'neurology', 'مغز و اعصاب', 'Neurology', 9 UNION ALL
  SELECT 'psychiatry', 'روانپزشکی', 'Psychiatry', 10 UNION ALL
  SELECT 'dermatology', 'پوست', 'Dermatology', 11 UNION ALL
  SELECT 'surgery', 'جراحی عمومی', 'General Surgery', 12 UNION ALL
  SELECT 'orthopedics', 'ارتوپدی', 'Orthopedics', 13 UNION ALL
  SELECT 'pediatrics', 'اطفال', 'Pediatrics', 14 UNION ALL
  SELECT 'obstetrics', 'زنان و زایمان', 'Obstetrics & Gynecology', 15
) v
WHERE s.slug='medicine';

-- ----------------------
-- Subspecialties (Dentistry / board_promotion)
-- ----------------------
INSERT IGNORE INTO subspecialties (specialty_id, exam_level_id, slug, name_fa, name_en, display_order)
SELECT
  s.id,
  l.id,
  v.slug,
  v.name_fa,
  v.name_en,
  v.display_order
FROM specialties s
JOIN exam_levels l ON l.specialty_id=s.id AND l.slug='board_promotion'
JOIN (
  SELECT 'orthodontics' AS slug, 'ارتودنسی' AS name_fa, 'Orthodontics' AS name_en, 1 AS display_order UNION ALL
  SELECT 'periodontics', 'پریودنتیکس', 'Periodontics', 2 UNION ALL
  SELECT 'endodontics', 'اندودنتیکس', 'Endodontics', 3 UNION ALL
  SELECT 'prosthodontics', 'پروتزهای دندانی', 'Prosthodontics', 4 UNION ALL
  SELECT 'oral_surgery', 'جراحی دهان و فک', 'Oral & Maxillofacial Surgery', 5 UNION ALL
  SELECT 'pediatric_dentistry', 'دندانپزشکی کودکان', 'Pediatric Dentistry', 6 UNION ALL
  SELECT 'oral_pathology', 'پاتولوژی دهان', 'Oral Pathology', 7
) v
WHERE s.slug='dentistry';

-- ----------------------
-- Exam type classification
-- ----------------------
INSERT IGNORE INTO exam_types_classification (slug, name_fa, display_order) VALUES
('past_year', 'آزمون سال‌های قبل', 1),
('authored', 'سوالات تألیفی', 2),
('combined', 'آزمون ترکیبی', 3),
('comprehensive', 'آزمون جامع', 4),
('custom', 'آزمون سفارشی', 5);

-- ----------------------
-- Sample content (Medicine / board_promotion / infectious)
-- ----------------------
INSERT IGNORE INTO courses (specialty_id, exam_level_id, subspecialty_id, slug, name_fa, main_reference, display_order)
SELECT
  s.id,
  l.id,
  ss.id,
  'harrison-infectious',
  'بیماری‌های عفونی - هاریسون',
  'Harrison\'s Principles of Internal Medicine',
  1
FROM specialties s
JOIN exam_levels l ON l.specialty_id=s.id AND l.slug='board_promotion'
JOIN subspecialties ss ON ss.specialty_id=s.id AND ss.exam_level_id=l.id AND ss.slug='infectious'
WHERE s.slug='medicine';

INSERT IGNORE INTO chapters (course_id, slug, name_fa, chapter_number, estimated_study_time, display_order)
SELECT
  c.id,
  'bacterial-infections',
  'عفونت‌های باکتریال',
  1,
  180,
  1
FROM courses c
WHERE c.slug='harrison-infectious';

INSERT IGNORE INTO topics (chapter_id, slug, name_fa, estimated_study_time, display_order)
SELECT
  ch.id,
  'staph-aureus',
  'استافیلوکوکوس اورئوس',
  30,
  1
FROM chapters ch
JOIN courses c ON c.id=ch.course_id
WHERE c.slug='harrison-infectious' AND ch.slug='bacterial-infections';

-- ----------------------
-- Sample exam (past year)
-- ----------------------
INSERT IGNORE INTO exams (
  specialty_id, exam_level_id, subspecialty_id, exam_type_classification_id,
  title, slug, exam_year, exam_date, total_questions, duration_minutes, is_published
)
SELECT
  s.id,
  l.id,
  ss.id,
  etc.id,
  'آزمون ارتقا عفونی ۱۴۰۳',
  'infectious-promotion-1403',
  1403,
  '2024-09-15',
  100,
  120,
  TRUE
FROM specialties s
JOIN exam_levels l ON l.specialty_id=s.id AND l.slug='board_promotion'
JOIN subspecialties ss ON ss.specialty_id=s.id AND ss.exam_level_id=l.id AND ss.slug='infectious'
JOIN exam_types_classification etc ON etc.slug='past_year'
WHERE s.slug='medicine';

-- ----------------------
-- One sample question + options + explanation (برای تست سریع)
-- ----------------------
INSERT INTO questions (
  specialty_id, exam_level_id, subspecialty_id,
  course_id, chapter_id, topic_id,
  question_text, difficulty, source, source_year, source_exam_id
)
SELECT
  s.id,
  l.id,
  ss.id,
  c.id,
  ch.id,
  t.id,
  'شایع‌ترین عامل عفونت خون بیمارستانی (Nosocomial bloodstream infection) کدام است؟',
  'medium',
  'نمونه تست سیستم',
  1403,
  e.id
FROM specialties s
JOIN exam_levels l ON l.specialty_id=s.id AND l.slug='board_promotion'
JOIN subspecialties ss ON ss.specialty_id=s.id AND ss.exam_level_id=l.id AND ss.slug='infectious'
JOIN courses c ON c.specialty_id=s.id AND c.exam_level_id=l.id AND c.subspecialty_id=ss.id AND c.slug='harrison-infectious'
JOIN chapters ch ON ch.course_id=c.id AND ch.slug='bacterial-infections'
JOIN topics t ON t.chapter_id=ch.id AND t.slug='staph-aureus'
JOIN exams e ON e.slug='infectious-promotion-1403'
WHERE s.slug='medicine'
LIMIT 1;

INSERT INTO question_options (question_id, option_number, option_text, is_correct)
SELECT q.id, 1, 'استافیلوکوکوس اورئوس', FALSE FROM questions q WHERE q.source='نمونه تست سیستم' ORDER BY q.id DESC LIMIT 1;
INSERT INTO question_options (question_id, option_number, option_text, is_correct)
SELECT q.id, 2, 'استرپتوکوکوس پنومونیه', FALSE FROM questions q WHERE q.source='نمونه تست سیستم' ORDER BY q.id DESC LIMIT 1;
INSERT INTO question_options (question_id, option_number, option_text, is_correct)
SELECT q.id, 3, 'اشرشیا کلی', TRUE FROM questions q WHERE q.source='نمونه تست سیستم' ORDER BY q.id DESC LIMIT 1;
INSERT INTO question_options (question_id, option_number, option_text, is_correct)
SELECT q.id, 4, 'سودوموناس آئروژینوزا', FALSE FROM questions q WHERE q.source='نمونه تست سیستم' ORDER BY q.id DESC LIMIT 1;

INSERT INTO question_explanations (question_id, explanation_text, references)
SELECT q.id,
       'این یک سوال نمونه برای تست اولیه سیستم است. در نسخه نهایی، پاسخ تشریحی طولانی (HTML/Markdown) و رفرنس‌ها اضافه می‌شود.',
       'Harrison; Mandell'
FROM questions q WHERE q.source='نمونه تست سیستم' ORDER BY q.id DESC LIMIT 1;

-- Link sample question to exam
INSERT IGNORE INTO exam_questions (exam_id, question_id, question_order, points)
SELECT e.id, q.id, 1, 1.00
FROM exams e
JOIN questions q ON q.source_exam_id=e.id
WHERE e.slug='infectious-promotion-1403'
ORDER BY q.id DESC
LIMIT 1;
