# frozen_string_literal: true

require "test_helper"

class ThemesTest < Minitest::Test
  def teardown
    ActiveAdmin::Themes.instance_variable_set(:@theme, nil)
  end

  def test_no_theme_by_default
    assert_nil ActiveAdmin::Themes.theme
    assert_nil ActiveAdmin::Themes.stylesheet_href
    assert_empty ActiveAdmin::Themes.view_paths
  end

  def test_use_accepts_strings_and_symbols
    ActiveAdmin::Themes.use "classic"

    assert_equal :classic, ActiveAdmin::Themes.theme
  end

  def test_use_rejects_unknown_themes
    error = assert_raises(ArgumentError) { ActiveAdmin::Themes.use :neon }

    assert_includes error.message, ":neon"
    assert_includes error.message, "compact, classic"
  end

  def test_stylesheet_href_is_versioned_and_digested
    ActiveAdmin::Themes.use :compact

    assert_match %r{\A/active_admin_themes/#{Regexp.escape(ActiveAdmin::Themes::VERSION)}/compact\.css\?v=\h{12}\z}o,
                 ActiveAdmin::Themes.stylesheet_href
  end

  def test_digest_follows_the_css
    ActiveAdmin::Themes.use :compact
    compact = ActiveAdmin::Themes.digest
    ActiveAdmin::Themes.use :classic

    refute_equal compact, ActiveAdmin::Themes.digest
  end

  def test_classic_css_includes_compact_first
    compact = ActiveAdmin::Themes.css(:compact)
    classic = ActiveAdmin::Themes.css(:classic)

    assert classic.start_with?(compact)
    assert_operator classic.length, :>, compact.length
  end

  def test_every_theme_has_its_files
    ActiveAdmin::Themes::THEMES.each_key do |name|
      ActiveAdmin::Themes.use name

      refute_empty ActiveAdmin::Themes.css(name)
      ActiveAdmin::Themes.view_paths.each { |path| assert_path_exists path }
    end
  end

  def test_view_paths_are_most_specific_first
    ActiveAdmin::Themes.use :classic

    assert_equal(%w[classic base], ActiveAdmin::Themes.view_paths.map { |path| File.basename(path) })
  end
end
