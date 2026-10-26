# frozen_string_literal: true

# Boot Rails before the gem loads, as an app does, so its Railtie runs.
require_relative "../dummy/application"
require "test_helper"

class AdminTest < Minitest::Test
  CONFIG = ActiveAdmin::Themes.config

  def test_dashboard_renders
    status, html = get("/admin")

    assert_equal 200, status
    assert_includes html, "Welcome"
  end

  def test_index_with_scopes_and_filters_renders
    Product.create!(name: "Desk lamp", status: "active", price: 25)
    status, html = get("/admin/products")

    assert_equal 200, status
    assert_includes html, "Desk lamp"
  ensure
    Product.delete_all
  end

  def test_stylesheet_link
    _, html = get("/admin")

    if CONFIG.stylesheets.empty?
      refute_includes html, "/active_admin_themes/"
    else
      aa = html.index(/<link[^>]+active_admin[^>]*\.css/)
      theme = html.index(%(href="#{ActiveAdmin::Themes.stylesheet_href.gsub("&", "&amp;")}"))

      assert theme, "theme stylesheet is linked"
      assert_operator aa, :<, theme, "theme stylesheet comes after ActiveAdmin's"
    end
  end

  def test_theme_stylesheet_is_served_by_the_app
    skip "no settings" if CONFIG.stylesheets.empty?
    status, css = get(ActiveAdmin::Themes.stylesheet_href)

    assert_equal 200, status
    assert_equal ActiveAdmin::Themes.css, css
  end

  def test_top_navigation
    _, html = get("/admin/products")

    if CONFIG.navigation == :top
      assert_includes html, "aat-nav"
      assert_includes html, "Catalog"
    else
      refute_includes html, "aat-"
    end
  end

  def test_pages_outside_active_admin_are_untouched
    _, paths = get("/plain")

    assert_includes paths, "app/views"
    refute_includes paths, "active_admin_themes"
  end

  private

  def get(path)
    status, _headers, body = Rails.application.call(Rack::MockRequest.env_for(path))
    html = +""
    body.each { |part| html << part }
    body.close if body.respond_to?(:close)
    [status, html]
  end
end
