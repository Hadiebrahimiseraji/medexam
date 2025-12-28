# 🤘 Contributing to MedExam

## برای شروع کردن

1. **Fork** this repository
2. **Clone** your fork
3. **Create** a feature branch: `git checkout -b feature/your-feature`
4. **Make** your changes
5. **Commit** with clear messages
6. **Push** to your fork
7. **Create** a Pull Request

## راهنمایی کود

### Database Changes

```bash
# 1. Test locally first
mysql -u root -p medexam < database/schema.sql

# 2. Use schema versioning
# Add date to changes: schema_20251229.sql

# 3. Document all changes
# Update database/README.md

# 4. Test data migrations
mysql -u root -p medexam < database/seed.sql
```

### SQL Standards

- ✅ Use UTF8MB4 charset
- ✅ Add Persian names (name_fa)
- ✅ Include timestamps
- ✅ Use foreign keys
- ✅ Add indexes for performance
- ✅ Comment complex queries

### Git Commit Messages

```
[feature/fix/docs] Brief description

Detailed explanation of changes

Related to: #issue_number
```

**Examples:**
```
[feature] Add dermatology subspecialty questions
[fix] Correct FK constraint in user_answers
[docs] Update database schema documentation
```

## Testing Requirements

Before creating a PR:

- [ ] Schema validates without errors
- [ ] Seed data loads completely
- [ ] All foreign keys work
- [ ] No duplicate entries
- [ ] Character encoding is correct
- [ ] Docker stack starts successfully
- [ ] GitHub Actions passes

## Code Review

Our maintainers will review your PR and may ask for:

- Code explanations
- Test cases
- Documentation updates
- Database impact analysis

## Issues

### Report Bugs

```
Title: [BUG] Brief description

Description:
- What happened?
- Expected behavior?
- Steps to reproduce?
- Your environment?
```

### Feature Requests

```
Title: [FEATURE] Brief description

Description:
- Why is this needed?
- How should it work?
- Database changes needed?
- Examples?
```

## Standards

### File Organization

```
project-root/
├── database/
│   ├── schema.sql (tables)
│   ├── seed.sql (initial data)
│   ├── migrations/ (version updates)
│   └── README.md
├── .github/
│   ├── workflows/
│   │   └── main.yml
│   ├── SETUP.md
│   └── QUICKSTART.md
└── documentation files
```

### Naming Conventions

**Tables:** Plural, snake_case
```sql
specialties, exam_levels, user_answers
```

**Columns:** snake_case
```sql
id, name_fa, is_active, created_at
```

**Indexes:** idx_purpose
```sql
idx_slug, idx_active, idx_specialty_level
```

**Foreign Keys:** fk_source_target
```sql
FOREIGN KEY (specialty_id) REFERENCES specialties(id)
```

## Documentation Standards

### README Files

- Clear title
- Quick start section
- Feature list
- Installation steps
- Usage examples
- Troubleshooting

### Code Comments

```sql
-- ========================================
-- TABLE: user_answers
-- PURPOSE: Store user responses to questions
-- ========================================
```

### Database Documentation

```markdown
### Table Name

Purpose: Brief description

Fields:
- id: Primary key
- user_id: FK to users

Indexes:
- idx_user: For fast lookup by user
```

## Branching Strategy

### Main Branch
- `main`: Production-ready code
- Protected branch
- Requires PR review
- Triggers CI/CD

### Development Branch
- `develop`: Feature integration
- Base for feature branches
- Weekly merges to main

### Feature Branches
- `feature/*`: New features
- `bugfix/*`: Bug fixes
- `docs/*`: Documentation
- `chore/*`: Maintenance

## Release Process

1. Create release branch: `release/v1.0.0`
2. Update version numbers
3. Update CHANGELOG
4. Create PR to main
5. Tag after merge: `v1.0.0`
6. Create GitHub Release

## License

By contributing, you agree your work is licensed under the same license as the project.

## Questions?

Open an issue or contact the maintainers.

---

**Thank you for contributing! 🙏**
