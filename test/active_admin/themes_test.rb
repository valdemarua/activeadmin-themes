# frozen_string_literal: true

require "test_helper"

class ThemesTest < Minitest::Test
  def teardown
    ActiveAdmin::Themes.reset!
  end

  def test_defaults_are_active_admins_own
    assert_equal({ navigation: :sidebar, density: :default, scopes: :default, style: :default },
                 ActiveAdmin::Themes.config.to_h)
    assert_nil ActiveAdmin::Themes.stylesheet_href
    assert_empty ActiveAdmin::Themes.view_paths
  end

  def test_configure_accepts_strings_and_symbols
    ActiveAdmin::Themes.configure do |c|
      c.navigation = "top"
      c.density = :compact
    end

    assert_equal :top, ActiveAdmin::Themes.config.navigation
    assert_equal :compact, ActiveAdmin::Themes.config.density
  end

  def test_configure_rejects_unknown_values
    error = assert_raises(ArgumentError) { ActiveAdmin::Themes.configure { |c| c.density = :tiny } }

    assert_includes error.message, "density :tiny"
    assert_includes error.message, ":default, :compact"
  end

  def test_presets
    ActiveAdmin::Themes.use :classic

    assert_equal({ navigation: :top, density: :compact, scopes: :chips, style: :classic },
                 ActiveAdmin::Themes.config.to_h)
  end

  def test_a_preset_resets_settings_it_does_not_name
    ActiveAdmin::Themes.use :classic
    ActiveAdmin::Themes.use "compact"

    assert_equal({ navigation: :sidebar, density: :compact, scopes: :chips, style: :default },
                 ActiveAdmin::Themes.config.to_h)
  end

  def test_use_rejects_unknown_presets
    error = assert_raises(ArgumentError) { ActiveAdmin::Themes.use :neon }

    assert_includes error.message, ":neon"
    assert_includes error.message, "compact, classic"
  end

  def test_stylesheets_are_the_non_default_settings_in_a_fixed_order
    ActiveAdmin::Themes.configure do |c|
      c.style = :classic
      c.density = :compact
      c.navigation = :top
    end

    assert_equal %w[navigation-top density-compact style-classic], ActiveAdmin::Themes.config.stylesheets
  end

  def test_stylesheet_href_names_the_stylesheets_and_their_digest
    ActiveAdmin::Themes.use :compact
    version = Regexp.escape(ActiveAdmin::Themes::VERSION)

    assert_match %r{\A/active_admin_themes/#{version}/density-compact\+scopes-chips\.css\?v=\h{12}\z},
                 ActiveAdmin::Themes.stylesheet_href
  end

  def test_digest_follows_the_css
    refute_equal ActiveAdmin::Themes.digest(%w[density-compact]),
                 ActiveAdmin::Themes.digest(%w[density-compact scopes-chips])
  end

  def test_css_concatenates_in_the_given_order
    density = ActiveAdmin::Themes.css(%w[density-compact])
    scopes = ActiveAdmin::Themes.css(%w[scopes-chips])

    assert_equal "#{density}\n#{scopes}", ActiveAdmin::Themes.css(%w[density-compact scopes-chips])
  end

  def test_every_stylesheet_exists
    ActiveAdmin::Themes::STYLESHEETS.each { |name| refute_empty ActiveAdmin::Themes.css([name]) }
  end

  def test_presets_use_known_settings
    ActiveAdmin::Themes::PRESETS.each_key { |preset| ActiveAdmin::Themes.use preset }
  end

  def test_view_paths_without_top_navigation
    ActiveAdmin::Themes.configure { |c| c.density = :compact }

    assert_equal %w[base], view_path_names
  end

  def test_view_paths_with_top_navigation_are_most_specific_first
    ActiveAdmin::Themes.configure { |c| c.navigation = :top }

    assert_equal %w[top base], view_path_names
    ActiveAdmin::Themes.view_paths.each { |path| assert_path_exists path }
  end

  private

  def view_path_names = ActiveAdmin::Themes.view_paths.map { |path| File.basename(path) }
end
