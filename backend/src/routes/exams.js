const express = require('express');
const router = express.Router();
const pool = require('../config/database');

// GET /api/v1/exams
router.get('/', async (req, res) => {
  try {
    const { specialty_id, exam_level_id, subspecialty_id, exam_type, year } = req.query;

    let query = `
      SELECT e.* FROM exams e
      WHERE e.is_active = TRUE
    `;
    const params = [];

    if (specialty_id) {
      query += ' AND e.specialty_id = ?';
      params.push(specialty_id);
    }
    if (exam_level_id) {
      query += ' AND e.exam_level_id = ?';
      params.push(exam_level_id);
    }
    if (subspecialty_id) {
      query += ' AND e.subspecialty_id = ?';
      params.push(subspecialty_id);
    }
    if (exam_type) {
      query += ` AND e.exam_type_classification_id = (SELECT id FROM exam_types_classification WHERE slug = ?)`;
      params.push(exam_type);
    }
    if (year) {
      query += ' AND e.exam_year = ?';
      params.push(year);
    }

    query += ' ORDER BY e.exam_year DESC, e.exam_date DESC';

    const [exams] = await pool.query(query, params);

    res.json({ data: exams });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch exams' });
  }
});

// POST /api/v1/exams/:exam_id/start
router.post('/:exam_id/start', async (req, res) => {
  try {
    const { exam_id } = req.params;
    const user_id = req.user?.id; // Assuming middleware sets user

    // Get exam
    const [exam] = await pool.query('SELECT * FROM exams WHERE id = ?', [exam_id]);
    if (exam.length === 0) {
      return res.status(404).json({ error: 'Exam not found' });
    }

    // Create attempt
    const [result] = await pool.query(
      'INSERT INTO user_exam_attempts (user_id, exam_id, status) VALUES (?, ?, ?)',
      [user_id, exam_id, 'in_progress']
    );

    const attempt_id = result.insertId;

    // Get questions
    const [questions] = await pool.query(
      `SELECT q.*, eq.question_order, eq.points 
       FROM questions q
       JOIN exam_questions eq ON q.id = eq.question_id
       WHERE eq.exam_id = ?
       ORDER BY eq.question_order ASC`,
      [exam_id]
    );

    // Get options for each question
    const questionsWithOptions = await Promise.all(
      questions.map(async (question) => {
        const [options] = await pool.query(
          'SELECT id, option_number, option_text FROM question_options WHERE question_id = ?',
          [question.id]
        );
        return {
          id: question.id,
          question_text: question.question_text,
          question_type: question.question_type,
          options,
          question_order: question.question_order
        };
      })
    );

    res.json({
      data: {
        attempt_id,
        exam: exam[0],
        questions: questionsWithOptions,
        started_at: new Date().toISOString(),
        expires_at: new Date(Date.now() + exam[0].duration_minutes * 60 * 1000).toISOString()
      }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to start exam' });
  }
});

// POST /api/v1/attempts/:attempt_id/answers
router.post('/:attempt_id/answers', async (req, res) => {
  try {
    const { attempt_id } = req.params;
    const { question_id, selected_option_id } = req.body;

    // Check if option is correct
    const [option] = await pool.query(
      'SELECT is_correct FROM question_options WHERE id = ?',
      [selected_option_id]
    );

    if (option.length === 0) {
      return res.status(400).json({ error: 'Invalid option' });
    }

    const is_correct = option[0].is_correct;

    // Get correct option
    const [correctOption] = await pool.query(
      'SELECT id FROM question_options WHERE question_id = ? AND is_correct = TRUE',
      [question_id]
    );

    // Save answer
    await pool.query(
      'INSERT INTO user_answers (attempt_id, question_id, selected_option_id, is_correct) VALUES (?, ?, ?, ?)',
      [attempt_id, question_id, selected_option_id, is_correct]
    );

    res.json({
      success: true,
      is_correct,
      correct_option_id: correctOption[0]?.id
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to save answer' });
  }
});

// POST /api/v1/attempts/:attempt_id/complete
router.post('/:attempt_id/complete', async (req, res) => {
  try {
    const { attempt_id } = req.params;

    // Get all answers
    const [answers] = await pool.query(
      'SELECT * FROM user_answers WHERE attempt_id = ?',
      [attempt_id]
    );

    // Calculate scores
    const correct_answers = answers.filter(a => a.is_correct).length;
    const wrong_answers = answers.filter(a => !a.is_correct).length;
    const total_questions = answers.length;
    const score = correct_answers;
    const percentage = (correct_answers / total_questions * 100).toFixed(2);

    // Update attempt
    await pool.query(
      `UPDATE user_exam_attempts 
       SET status = ?, completed_at = NOW(), correct_answers = ?, wrong_answers = ?, total_questions = ?, score = ?, percentage = ?
       WHERE id = ?`,
      ['completed', correct_answers, wrong_answers, total_questions, score, percentage, attempt_id]
    );

    res.json({
      data: {
        attempt_id,
        score,
        percentage,
        correct_answers,
        wrong_answers,
        total_questions
      }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to complete exam' });
  }
});

module.exports = router;
