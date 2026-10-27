# activeadmin-themes

Configurable layout and density for [ActiveAdmin](https://github.com/activeadmin/activeadmin) 4:
a sidebar or top navigation menu, compact sizing and compact scopes. Layered on
ActiveAdmin's own CSS and views, with no fork and no CSS build.

## Requirements

- ActiveAdmin 4.x (`>= 4.0.0.beta`, `< 5`). ActiveAdmin 3 and older are not supported.
- Rails 7.2 or newer
- Ruby 3.3 or newer

These match ActiveAdmin 4's own requirements.

The only runtime dependencies are `activeadmin` and `railties`.

## Installation

```ruby
# Gemfile
gem "activeadmin-themes"
```

```ruby
# config/initializers/active_admin_themes.rb
ActiveAdmin::Themes.configure do |c|
  c.navigation = :top
  c.density    = :compact
  c.scopes     = :chips
end
```

Restart the server. Without configuration, the gem changes nothing.

## Settings

Each part of the look is a separate setting, so you can combine them freely.

| Setting | Values | Default | What it changes |
|---|---|---|---|
| `navigation` | `:sidebar`, `:top` | `:sidebar` | The sidebar menu, or a horizontal top bar with dropdowns (on hover and keyboard focus, no JavaScript). On narrow screens the top menu scrolls sideways. |
| `density` | `:default`, `:compact` | `:default` | About 25% denser: spacing, type size, table rows, filter column width, form control padding |
| `scopes` | `:default`, `:chips` | `:default` | ActiveAdmin's joined scope buttons, or separate, smaller chips with plain-text counts that wrap cleanly when there are many |
| `style` | `:default`, `:classic` | `:default` | Colors and surfaces only: ActiveAdmin's own, or a look after ActiveAdmin 1–3: a gray top bar, light gray gradient headers (title bar, tables, panels, a boxed filters panel), striped rows, gray buttons that lighten on hover and muted steel-blue links |

Every default is ActiveAdmin's own behavior, so leaving a setting out keeps
ActiveAdmin's look for that part. All settings support light and dark mode.

### Presets

Instead of `configure`, `use` sets a named combination:

```ruby
# config/initializers/active_admin_themes.rb
ActiveAdmin::Themes.use :compact
```

| Preset | Settings |
|---|---|
| `:compact` | `density: :compact`, `scopes: :chips` |
| `:classic` | `navigation: :top`, `density: :compact`, `scopes: :chips`, `style: :classic` |

Settings a preset doesn't name stay at their defaults.

## With or without activeadmin_assets

The gem works the same however ActiveAdmin's own CSS reaches the browser:

- **With [activeadmin_assets](https://github.com/jaynetics/activeadmin_assets)**:
  ActiveAdmin 4 with no asset pipeline at all (no Sprockets, Propshaft, Tailwind
  build or `assets:precompile`). Add both gems and you're done.
- **Without it**: your app builds ActiveAdmin's CSS with Tailwind, as ActiveAdmin's
  installer sets up. Nothing extra is needed either.

The gem never goes through your asset pipeline. Each setting that differs from the
default adds a small plain-CSS file. A Rack middleware serves the ones in use from the
gem as one stylesheet (e.g. `/active_admin_themes/<version>/density-compact+scopes-chips.css`),
with a content digest in the URL and a one-year cache. The top navigation markup only
uses its own `aat-*` classes, styled by that CSS, plus Tailwind classes ActiveAdmin's
own layout already uses, so nothing has to be added to a Tailwind build.

## How it works

- **Sizing**: ActiveAdmin 4 is built with Tailwind v4, whose spacing and type
  utilities read CSS variables (`--spacing`, `--text-*`). Overriding a few of them
  rescales the whole UI; a few selectors handle the rest.
- **Views**: the gem's partials are added to the view path of ActiveAdmin's
  controllers only (admin pages and ActiveAdmin's Devise pages). `_html_head` adds
  the stylesheet after ActiveAdmin's; `navigation: :top` also overrides the layout,
  `_site_header` and `_main_navigation`. Your own overrides in `app/views` still win,
  and the rest of your app is untouched.

## Customizing

The CSS is loaded after ActiveAdmin's, so your own admin CSS can override it as
usual. Colors are CSS variables on `:root` (and `:root.dark` for dark mode):

- Top bar (`navigation: :top`): `--aat-bar`, `--aat-bar-border`, `--aat-bar-brand`,
  `--aat-bar-text`, `--aat-bar-text-hover`, `--aat-bar-hover`, `--aat-bar-current`,
  `--aat-bar-current-text`, and `--aat-menu*` for the dropdowns.
- `style: :classic`: `--aat-header*` (title bar, table and panel headers),
  `--aat-primary*` (submit buttons, checkboxes, current page), `--aat-button*`
  (action items), `--aat-stripe` (table rows). Links use ActiveAdmin's own
  `--color-blue-*` variables.

## Status

Early. Tested against ActiveAdmin 4.0.0.beta23 and activeadmin_assets 1.3.0, on
Rails 7.2, 8.0 and 8.1. Since the gem builds on ActiveAdmin's markup and class names,
check your admin after upgrading ActiveAdmin while 4.x is in beta.

## License

MIT
