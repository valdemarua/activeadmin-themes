# Agent Instructions

`activeadmin-themes` restyles ActiveAdmin 4 through a few independent settings
(navigation, density, scopes, style), layered on top of AA's own CSS and views.
Design and roadmap: `docs/PLAN.md`. Read it before changing the public API.

## Architecture

- `lib/active_admin/themes.rb`: the public API (`configure`, `use` for presets), the
  stylesheet URL with its content digest, and the view paths.
- `lib/active_admin/themes/config.rb`: `SETTINGS` (each with its allowed values, the
  default first), `PRESETS`, and `Config`, which validates values on assignment.
- `lib/active_admin/themes/middleware.rb`: serves the stylesheets in use, concatenated,
  at `/active_admin_themes/<version>/<name>+<name>.css?v=<digest>` with a one-year
  immutable cache. Only names from `STYLESHEETS` are served.
- `lib/active_admin/themes/railtie.rb`: inserts the middleware and prepends the
  gem's view paths on `ActiveAdmin::BaseController` and AA's Devise controllers only.
- `lib/active_admin/themes/assets/<setting>-<value>.css`: one plain-CSS file per
  non-default value, no build step. They load in `SETTINGS` order, so `style-*` comes
  last and overrides the `--aat-*` color variables the others define. A `style-*`
  file puts every color in `--aat-*` variables at the top (light, then dark) and its
  rules use only those variables, so a new style starts by copying the variables.
- `app/views/active_admin_themes/<set>/`: AA partial overrides. `base` adds the
  stylesheet `<link>` after AA's; `top` swaps in the top-navigation layout.

## Rules

- Layer on AA; never fork it. The CSS loads after AA's stylesheet and works the same
  whether AA's CSS comes from [activeadmin_assets](https://github.com/jaynetics/activeadmin_assets)
  or from the app's own Tailwind build.
- Rescale through AA's Tailwind v4 variables (`--spacing`, `--text-*`) before
  writing selectors. Target only class names and variables AA already outputs.
- Markup in the gem's views must not depend on Tailwind classes AA doesn't ship.
  Style it with the gem's own `aat-*` classes.
- A setting is either CSS-only or a whole-layout swap (like `navigation`). Never add
  a setting that edits individual AA partials piecemeal; that belongs upstream in AA.
- With no configuration the gem changes nothing.
- Every visual change works in light and dark mode, and on mobile widths. Keep AA's
  hooks that its JS relies on (e.g. the `.dark-mode-toggle` class).
- Override as few AA partials as possible. Each copied partial must be re-checked
  against AA on every AA upgrade. App-level view overrides must still win.
- Runtime dependencies are `activeadmin` and `railties` only. Ask before adding another.
- Rails versions come from the `activeadmin` dependency: never pin `railties`.
  `required_ruby_version` is the minimum our own code runs on, never below
  ActiveAdmin's (today 3.3).
- The gem is client-agnostic. Never reference specific client apps or sites in code,
  tests, docs or issues. Names and examples are in English and generic.

## Workflow notes

- IMPORTANT: Never mention AI assistants or agents (Claude, Claude Code, Codex, Copilot, etc.) in commit messages, including `Co-Authored-By` trailers
- IMPORTANT: Never include "Test plan" sections in PR descriptions
- The standard location for documentation and specs is `docs/`
- Every user-visible change adds a line under `Unreleased` in `CHANGELOG.md`.

## Tools

- Setup: `bundle install`
- Everything CI runs: `bundle exec rake` (unit tests, integration tests, RuboCop).
- Unit tests (Minitest, no Rails): `bundle exec rake test`, in `test/active_admin/`.
- Integration tests: `bundle exec rake test:integration`. They boot the dummy app in
  `test/dummy/` (ActiveAdmin + activeadmin_assets, in-memory SQLite) once per
  combination in the Rakefile's `THEMES`, each in its own process
  (`test:integration:none`, `:compact`, `:classic`, `:top`).
  Other Rails versions: `BUNDLE_GEMFILE=gemfiles/rails_7_2.gemfile` (also `rails_8_0`, `rails_8_1`).
- Lint: `bundle exec rubocop`
- Dependencies used only by tests go in the `Gemfile`, never in the gemspec.
- Visual checks use the lab app in `../activeadmin-themes-lab` (AA 4 +
  activeadmin_assets, wide tables, many scopes and filters, a long menu), which loads
  this gem by path. Start it with `AA_THEME=<preset> bin/rails s -p 3100` or
  `AA_THEME="navigation=top,density=compact" bin/rails s -p 3100`, then take
  screenshots with `bundle exec ruby script/shots.rb <label> [path]` (`DARK=1` for dark
  mode, `SIZE=390,844` for mobile). Output goes to `tmp/shots/`. Look at the full
  images; macOS `sips` crops from the center.
- Releases: bump `lib/active_admin/themes/version.rb`, move the CHANGELOG entries,
  then tag `vX.Y.Z`. Publish through RubyGems trusted publishing from CI; never run
  `gem push` locally.
