# Plan

## Goal

ActiveAdmin 4 looks better than 3, but it is bigger and only has a sidebar menu, which
hurts dense, filter-heavy admin pages. This gem makes AA 4's layout and density
configurable without forking AA or adding an asset build, so an app can move to AA 4
(and, with activeadmin_assets, drop its asset pipeline) without losing the dense pages.

## How AA 4 makes this possible

- AA 4's views are ERB partials with Tailwind classes inline. The layout hardcodes
  the sidebar (`xl:ms-60`) and the fixed header (`pt-16`). Tables, forms, scopes and
  filters use component classes from AA's Tailwind plugin (`.data-table`, `.scopes`,
  `.filters-form`, `.panel`, `.formtastic`, …).
- Tailwind v4 sizes everything through CSS variables. AA's built CSS uses
  `var(--spacing)` about 200 times, and type sizes are `--text-*` variables, so
  changing a few variables rescales the whole UI.
- activeadmin_assets ships AA's built CSS and JS as static files. It doesn't allow
  custom Tailwind config or Tailwind classes that AA doesn't already use. That is
  why this gem uses plain CSS and its own `aat-*` classes.

## Settings

Independent settings; the two original themes are presets of them. User-facing
reference: the README.

| Setting | Changes | How |
|---|---|---|
| `navigation` | sidebar menu or top bar with dropdowns | layout swap: overrides the layout, `_site_header`, `_main_navigation` |
| `density` | spacing, type size, table rows, filter column width, control padding | CSS variables |
| `scopes` | AA's scope buttons or chips | CSS |
| `style` | colors and surfaces only | `--aat-*` variables, title bar |

Design:

- One small CSS file per non-default value. The middleware serves the ones in use
  as one stylesheet, named in the URL (`density-compact+scopes-chips.css`), so every
  combination works without a stylesheet per combination, with no runtime JS and no
  attributes on `<html>`.
- No configuration means no change: every setting defaults to AA's own behavior.
- Every combination is allowed. A combination that renders badly is a bug, not
  something to forbid with validation.
- Later, if wanted: a per-admin toggle (e.g. density) would need the settings as
  attributes on `<html>` and CSS scoped by them.
- Replace the copied `_html_head` with a smaller hook if possible, so the gem
  follows AA's partial instead of drifting from it.

## Testing

- A dummy app on AA 4 + activeadmin_assets.
- Screenshot comparisons of index (many scopes, filters, wide table), show, form and
  dashboard, in light and dark, desktop and mobile. Polish the main combinations
  first.
- A check that every class used in the gem's views exists in AA's built CSS.
- Run against more than one AA 4.x version, since the gem depends on AA's markup.

## Status

- Done against ActiveAdmin 4.0.0.beta23 and activeadmin_assets 1.3.0: the four
  settings and two presets, top navigation in AA's default and classic styles, light
  and dark mode, unit and integration tests on Rails 7.2, 8.0 and 8.1, CI.
- Next: a generic demo app with README screenshots in a minimal browser frame, then
  the first release (after AA 4.0 final, or pinned to the beta).
