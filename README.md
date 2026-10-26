# activeadmin-themes

Alternative themes for ActiveAdmin 4, layered on top of AA's own CSS.

- **Compact**: AA 4's layout (sidebar menu), about 25% denser. CSS only: AA 4 is
  built with Tailwind v4, whose spacing and type utilities read CSS variables
  (`--spacing`, `--text-*`), so a few overrides rescale everything.
- **Classic**: the AA 1-3 arrangement on AA 4: dark top bar with a horizontal
  menu (dropdowns on hover/focus, no JS), light title bar, filters on the right.
  Includes Compact's sizing. Light and dark mode.

Works with [activeadmin_assets](https://github.com/jaynetics/activeadmin_assets)
(no asset pipeline) or an app's own Tailwind build: themes are plain CSS loaded
after AA's stylesheet, served by a tiny middleware from the gem.

## Usage

```ruby
# Gemfile
gem "activeadmin_assets"
gem "activeadmin-themes"

# config/initializers/active_admin.rb
ActiveAdmin::Themes.use :compact   # or :classic
```

## How it hooks in

- `ActiveAdmin::Themes::Middleware` serves `/active_admin_themes/<version>/<theme>.css`.
- The view path of the theme is prepended only on ActiveAdmin's controllers (admin
  pages and AA's Devise pages). The shared `_html_head` adds the theme `<link>`
  right after AA's stylesheet; Classic also overrides the layout, `_site_header`
  and `_main_navigation`. App-level overrides still win.

## Status

Spike, tested against ActiveAdmin 4.0.0.beta23 + activeadmin_assets 1.3.0 in
`../activeadmin-themes-lab` (`AA_THEME=compact|classic bin/rails s -p 3100`,
screenshots with `bundle exec ruby script/shots.rb <label>`).
