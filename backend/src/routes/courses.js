const express = require('express');
const router = express.Router();
const pool = require('../config/database');

// GET /api/v1/courses
router.get('/', async (req, res) => {
  try {
    const { specialty_id, exam_level_id, subspecialty_id } = req.query;

    let query = 'SELECT * FROM courses WHERE is_active = TRUE';
    const params = [];

    if (specialty_id) {
      query += ' AND specialty_id = ?';
      params.push(specialty_id);
    }
    if (exam_level_id) {
      query += ' AND exam_level_id = ?';
      params.push(exam_level_id);
    }
    if (subspecialty_id) {
      query += ' AND subspecialty_id = ?';
      params.push(subspecialty_id);
    }

    query += ' ORDER BY display_order ASC';

    const [courses] = await pool.query(query, params);

    // Get chapters count for each course
    const result = await Promise.all(
      courses.map(async (course) => {
        const [chapters] = await pool.query(
          'SELECT COUNT(*) as count FROM chapters WHERE course_id = ? AND is_active = TRUE',
          [course.id]
        );
        return {
          ...course,
          chapters_count: chapters[0].count
        };
      })
    );

    res.json({ data: result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch courses' });
  }
});

// GET /api/v1/courses/:course_slug/chapters
router.get('/:course_slug/chapters', async (req, res) => {
  try {
    const { course_slug } = req.params;

    const [chapters] = await pool.query(
      `SELECT id, slug, name_fa, name_en, chapter_number, estimated_study_time, display_order 
       FROM chapters 
       WHERE course_id = (SELECT id FROM courses WHERE slug = ?) AND is_active = TRUE 
       ORDER BY display_order ASC`,
      [course_slug]
    );

    // Get topics count for each chapter
    const result = await Promise.all(
      chapters.map(async (chapter) => {
        const [topics] = await pool.query(
          'SELECT COUNT(*) as count FROM topics WHERE chapter_id = ? AND is_active = TRUE',
          [chapter.id]
        );
        return {
          ...chapter,
          topics_count: topics[0].count
        };
      })
    );

    res.json({ data: result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch chapters' });
  }
});

// GET /api/v1/chapters/:chapter_slug/topics
router.get('/:chapter_slug/topics', async (req, res) => {
  try {
    const { chapter_slug } = req.params;

    const [topics] = await pool.query(
      `SELECT id, slug, name_fa, name_en, estimated_study_time, display_order 
       FROM topics 
       WHERE chapter_id = (SELECT id FROM chapters WHERE slug = ?) AND is_active = TRUE 
       ORDER BY display_order ASC`,
      [chapter_slug]
    );

    // Get questions count for each topic
    const result = await Promise.all(
      topics.map(async (topic) => {
        const [questions] = await pool.query(
          'SELECT COUNT(*) as count FROM questions WHERE topic_id = ? AND is_active = TRUE',
          [topic.id]
        );
        return {
          ...topic,
          questions_count: questions[0].count
        };
      })
    );

    res.json({ data: result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch topics' });
  }
});

// GET /api/v1/topics/:topic_slug
router.get('/:topic_slug/view', async (req, res) => {
  try {
    const { topic_slug } = req.params;

    const [topic] = await pool.query(
      'SELECT * FROM topics WHERE slug = ? AND is_active = TRUE',
      [topic_slug]
    );

    if (topic.length === 0) {
      return res.status(404).json({ error: 'Topic not found' });
    }

    const [questions] = await pool.query(
      `SELECT q.id, q.question_text, q.question_type, q.difficulty 
       FROM questions q 
       WHERE q.topic_id = ? AND q.is_active = TRUE 
       LIMIT 15`,
      [topic[0].id]
    );

    // Get options for each question
    const questionsWithOptions = await Promise.all(
      questions.map(async (question) => {
        const [options] = await pool.query(
          'SELECT id, option_number, option_text FROM question_options WHERE question_id = ? ORDER BY option_number ASC',
          [question.id]
        );
        const [explanation] = await pool.query(
          'SELECT explanation_text, references FROM question_explanations WHERE question_id = ?',
          [question.id]
        );
        return {
          ...question,
          options,
          explanation: explanation[0] || null
        };
      })
    );

    res.json({
      data: {
        ...topic[0],
        questions: questionsWithOptions
      }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch topic' });
  }
});

module.exports = router;
