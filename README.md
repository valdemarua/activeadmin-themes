# activeadmin-themes

Alternative looks for [ActiveAdmin](https://github.com/activeadmin/activeadmin) 4.

ActiveAdmin 4 looks much better than 3, but it is roomier and only has a sidebar
menu, which costs a lot of space on dense admin pages: wide tables, many scopes, long
filter lists. This gem makes it denser and can bring back a horizontal top menu,
without forking ActiveAdmin or adding a CSS build to your app.

- **Compact**: ActiveAdmin 4's own layout (sidebar menu), about 25% denser: smaller
  spacing, type and table rows, a narrower filter column, and scopes shown as small chips.
- **Classic**: the ActiveAdmin 1–3 arrangement on ActiveAdmin 4: a gray top bar with
  a horizontal menu (dropdowns on hover and keyboard focus, no JavaScript), a light
  title bar and filters on the right. Includes Compact's sizing.

Both support light and dark mode and mobile widths.

## Requirements

- ActiveAdmin 4.x (`>= 4.0.0.beta`, `< 5`). ActiveAdmin 3 and older are not supported.
- Rails 7.1 or newer
- Ruby 3.3 or newer

The only runtime dependencies are `activeadmin` and `railties`.

## Installation

```ruby
# Gemfile
gem "activeadmin-themes"
```

```ruby
# config/initializers/active_admin.rb
ActiveAdmin::Themes.use :compact   # or :classic
```

Restart the server. Without `use`, the gem changes nothing.

## Settings

> Coming in the next release. Today the gem has the two fixed themes above:
> `:compact` and `:classic` are the combinations marked in the table.

Each part of the look is a separate setting, so you can combine them freely, e.g. a
top menu in ActiveAdmin's own colors at compact density:

```ruby
ActiveAdmin::Themes.configure do |c|
  c.navigation = :top
  c.density    = :compact
  c.scopes     = :chips
end
```

| Setting | Values | Default | What it changes | Compact | Classic |
|---|---|---|---|---|---|
| `navigation` | `:sidebar`, `:top` | `:sidebar` | Sidebar menu, or a horizontal top bar with dropdowns and a mobile menu | `:sidebar` | `:top` |
| `density` | `:default`, `:compact` | `:default` | Spacing, type size, table rows, filter column width, form control padding | `:compact` | `:compact` |
| `scopes` | `:default`, `:chips` | `:default` | ActiveAdmin's scope buttons, or small chips that fit more per row | `:chips` | `:chips` |
| `style` | `:default`, `:classic` | `:default` | Colors and surfaces only: ActiveAdmin's own, or a gray top bar and title bar | `:default` | `:classic` |

Every default is ActiveAdmin's own behavior, so an empty `configure` block changes
nothing. All settings support light and dark mode.

## With or without activeadmin_assets

The gem works the same however ActiveAdmin's own CSS reaches the browser:

- **With [activeadmin_assets](https://github.com/jaynetics/activeadmin_assets)**:
  ActiveAdmin 4 with no asset pipeline at all (no Sprockets, Propshaft, Tailwind
  build or `assets:precompile`). Add both gems and you're done.
- **Without it**: your app builds ActiveAdmin's CSS with Tailwind, as ActiveAdmin's
  installer sets up. Nothing extra is needed either.

The gem never goes through your asset pipeline. Its CSS is plain CSS served by a small
Rack middleware from the gem at `/active_admin_themes/<version>/<theme>.css`, with a
content digest in the URL and a one-year cache. The Classic markup only uses its own
`aat-*` classes, styled by that CSS, plus Tailwind classes ActiveAdmin's own layout
already uses, so nothing has to be added to a Tailwind build.

## How it works

- **Sizing**: ActiveAdmin 4 is built with Tailwind v4, whose spacing and type
  utilities read CSS variables (`--spacing`, `--text-*`). Overriding a few of them
  rescales the whole UI; a few selectors handle the rest.
- **Views**: the gem's partials are added to the view path of ActiveAdmin's
  controllers only (admin pages and ActiveAdmin's Devise pages). `_html_head` adds
  the theme stylesheet after ActiveAdmin's; Classic also overrides the layout,
  `_site_header` and `_main_navigation`. Your own overrides in `app/views` still win,
  and the rest of your app is untouched.

## Customizing

The CSS is loaded after ActiveAdmin's, so your own admin CSS can override it as
usual. Classic's colors are CSS variables on `.aat-classic` (`--aat-bar`,
`--aat-bar-text`, `--aat-bar-hover`, `--aat-bar-current`).

## Status

Early. Tested against ActiveAdmin 4.0.0.beta23 and activeadmin_assets 1.3.0. Since
the gem builds on ActiveAdmin's markup and class names, check your admin after
upgrading ActiveAdmin while 4.x is in beta. The settings above will replace the two fixed
themes; see [docs/PLAN.md](docs/PLAN.md).

## License

MIT
