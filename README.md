# OpenClaw Contributor Skill

Automated issue analysis → root cause fix → comprehensive testing → PR submission workflow for OpenClaw contributors.

Inspired by [tyler6204's maintainer-skill](https://github.com/tyler6204/openclaw-maintainer-skill), adapted for contributors following 
[Mario Zechner's philosophy](https://twitter.com/mariozechner): **deep understanding > volume, quality > speed, iterate on feedback**.

## Quick Start

```bash
# 1. Analyze an issue
/analyzeissue #10238

# 2. Create the fix (after approval)
/createfix

# 3. Submit the PR (after testing)
/submitpr
```

## Workflow

### Phase 1: Analyze
- Deep dive into issue
- Identify root cause (not surface symptoms)
- Propose defensive solution
- Estimate effort and risk

### Phase 2: Fix
- Implement solution
- Write 3+ test cases
- Run local build & tests
- Commit with professional message
- Push to branch

### Phase 3: Submit
- Create PR with professional description
- Reference issue
- Include testing notes
- Submit to openclaw/openclaw

## Philosophy

This skill is built on proven principles:

✅ **Deep Understanding First**
- Don't code until you understand the root cause
- Trace through the entire code path
- Document findings clearly

✅ **Defensive Programming**
- Handle edge cases
- Add safety checks
- Use patterns from existing code

✅ **Comprehensive Testing**
- Minimum 3 test cases per fix
- Test normal case, edge cases, error cases
- Verify with local build + tests before submitting

✅ **Quality Gates**
- Build MUST pass locally
- Tests MUST pass locally
- No force pushes to main
- All PRs go through code review

✅ **Professional Communication**
- Clear commit messages
- Thorough PR descriptions
- Reference original issue
- Show testing evidence

✅ **Sustainable Pace**
- Target: 25 minutes per fix
- No rushing, no burnout
- Quality over volume
- Iterate based on feedback

## Key Features

### Automatic Analysis
- Fetches GitHub issue details
- Traces root cause in code
- Proposes solution approach
- Estimates difficulty

### Intelligent Fix Creation
- Implements defensive patterns
- Writes comprehensive tests
- Verifies local build passes
- Verifies all tests pass
- Creates professional commits

### Professional PR Submission
- Generates professional titles
- Writes detailed descriptions
- References original issue
- Includes testing evidence
- Submits via GitHub CLI

### Safety Guarantees
- NEVER force-pushes to main
- NEVER commits without tests
- NEVER submits without build passing
- All fixes pushed to branches only
- Code reaches main only via PR merge

## Configuration

Edit `config.yaml` to customize:

```yaml
models:
  analyze: opus           # Model for issue analysis
  fix: gpt                # Model for implementation
  submit: gpt             # Model for PR creation

quality_gates:
  min_test_cases: 3       # Minimum test cases required
  require_build_pass: true
  require_tests_pass: true
  defensive_patterns: true
```

## Intended Use

Perfect for:
- ✅ Fixing real bugs systematically
- ✅ Learning codebase deeply
- ✅ Building contributor reputation
- ✅ Establishing merge rate credibility
- ✅ Contributing to large projects sustainably

Not intended for:
- ❌ Spamming low-quality PRs
- ❌ Theater/volume metrics
- ❌ Skipping analysis or testing
- ❌ Surface-level fixes

## Results

Following this skill's workflow, expect:

Week 1: 5-8 merged PRs (establishing credibility)
Week 2: 10-13 total merged (momentum compounds)
Week 3: 20-25 total merged (pattern clear)
Week 4: 35-50 total merged (core contributor)

Success: 50+ merged PRs with 70%+ acceptance rate

## Inspiration

Built on principles from:
- Mario Zechner's shipping philosophy
- Tyler's maintainer-skill workflow
- OpenClaw's quality culture
- Real contributor experience

## License

Same as OpenClaw (Apache 2.0)

## Support

Issues and PRs to this skill repo:
https://github.com/arosstale/openclaw-contributor-skill

Original maintainer-skill:
https://github.com/tyler6204/openclaw-maintainer-skill
