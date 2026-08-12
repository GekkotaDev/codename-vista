## Pull Request Checklist

Please check if your pull request meets the following requirements:

- [ ] All public facing functions have documentation comments (double hashtag — not single — above each function declaration)
- [ ] Pull request commit message uses the template: `<type>(<scope>): <short summary>`
  - Examples: `fix(draw): detect pen input.`; `feat(assets): new player model`
  - Types: `build` | `chore` | `ci` | `docs` | `feat` | `fix` | `perf` | `refactor` | `spec`
  - Scope: Optional, additional info.
- [ ] Strictly **no** AI generated pull request messages, that is automatically considered spam and misleading. Use your own words.

## Pull Request Type

What kind of changes does your Pull Request include? This helps reviewers — likely your teammates — know what to expect.

- [ ] Bug fix
- [ ] New feature
- [ ] Refactoring (no behavioral changes, requires tests)
- [ ] Documentation update
- [ ] Build system change
- [ ] Github Workflows (CI) change
- [ ] Other: ...

## Current Behavior?

<!-- You may link repository issues / bug reports if necessary -->

## New Behavior?

## Does It *Potentially* Include a Breaking Change?

Does it introduce any one of the following:

- A `class_name` or function had been changed.
- A function that **doesn't return void** has its parameters and / or return data type changed.
- Any files not ending in `.gd` had been moved.
- A `[[dependency]]` had been removed or updated in `ggg.toml`

The answer is:

- [ ] Yes
- [x] No

## Other Information
