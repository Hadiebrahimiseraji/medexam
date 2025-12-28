const express = require('express');
const router = express.Router();
const pool = require('../config/database');

// GET /api/v1/specialties
router.get('/', async (req, res) => {
  try {
    const [specialties] = await pool.query(
      `SELECT id, slug, name_fa, name_en, icon, description, display_order 
       FROM specialties 
       WHERE is_active = TRUE 
       ORDER BY display_order ASC`
    );

    // Get count of exam levels for each specialty
    const result = await Promise.all(
      specialties.map(async (specialty) => {
        const [levels] = await pool.query(
          'SELECT COUNT(*) as count FROM exam_levels WHERE specialty_id = ? AND is_active = TRUE',
          [specialty.id]
        );
        return {
          ...specialty,
          exam_levels_count: levels[0].count
        };
      })
    );

    res.json({ data: result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch specialties' });
  }
});

// GET /api/v1/specialties/:specialty_slug/levels
router.get('/:specialty_slug/levels', async (req, res) => {
  try {
    const { specialty_slug } = req.params;

    const [specialty] = await pool.query(
      'SELECT id FROM specialties WHERE slug = ? AND is_active = TRUE',
      [specialty_slug]
    );

    if (specialty.length === 0) {
      return res.status(404).json({ error: 'Specialty not found' });
    }

    const [levels] = await pool.query(
      `SELECT id, slug, name_fa, name_en, icon, requires_subspecialty, display_order 
       FROM exam_levels 
       WHERE specialty_id = ? AND is_active = TRUE 
       ORDER BY display_order ASC`,
      [specialty[0].id]
    );

    // Get subspecialties count for levels that require it
    const result = await Promise.all(
      levels.map(async (level) => {
        if (level.requires_subspecialty) {
          const [subspecialties] = await pool.query(
            'SELECT COUNT(*) as count FROM subspecialties WHERE exam_level_id = ? AND is_active = TRUE',
            [level.id]
          );
          return {
            ...level,
            subspecialties_count: subspecialties[0].count
          };
        }
        return level;
      })
    );

    res.json({ data: result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch levels' });
  }
});

// GET /api/v1/specialties/:specialty_slug/levels/:level_slug/subspecialties
router.get('/:specialty_slug/levels/:level_slug/subspecialties', async (req, res) => {
  try {
    const { specialty_slug, level_slug } = req.params;

    const [level] = await pool.query(
      `SELECT el.id FROM exam_levels el
       JOIN specialties s ON el.specialty_id = s.id
       WHERE s.slug = ? AND el.slug = ? AND el.is_active = TRUE`,
      [specialty_slug, level_slug]
    );

    if (level.length === 0) {
      return res.status(404).json({ error: 'Level not found' });
    }

    const [subspecialties] = await pool.query(
      `SELECT id, slug, name_fa, name_en, description, display_order 
       FROM subspecialties 
       WHERE exam_level_id = ? AND is_active = TRUE 
       ORDER BY display_order ASC`,
      [level[0].id]
    );

    res.json({ data: subspecialties });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch subspecialties' });
  }
});

module.exports = router;
