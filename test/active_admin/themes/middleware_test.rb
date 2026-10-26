# frozen_string_literal: true

require "test_helper"

class MiddlewareTest < Minitest::Test
  APP = ->(_env) { [200, {}, ["app"]] }

  def test_passes_other_paths_through
    assert_equal ["app"], get("/admin")[2]
  end

  def test_serves_the_named_stylesheets
    status, headers, body = get("/active_admin_themes/#{ActiveAdmin::Themes::VERSION}/navigation-top+style-classic.css")

    assert_equal 200, status
    assert_equal "text/css; charset=utf-8", headers["content-type"]
    assert_equal "public, max-age=31536000, immutable", headers["cache-control"]
    assert_equal ActiveAdmin::Themes.css(%w[navigation-top style-classic]), body.join
  end

  def test_serves_any_combination_whatever_is_configured
    assert_equal 200, get("/active_admin_themes/x/density-compact.css")[0]
  end

  def test_unknown_stylesheets_are_not_found
    assert_equal 404, get("/active_admin_themes/x/density-tiny.css")[0]
    assert_equal 404, get("/active_admin_themes/x/density-compact+neon.css")[0]
    assert_equal 404, get("/active_admin_themes/x/density-default.css")[0]
  end

  def test_only_stylesheet_names_are_read
    assert_equal 404, get("/active_admin_themes/x/../../../Gemfile.css")[0]
    assert_equal 404, get("/active_admin_themes/x/.css")[0]
    assert_equal 404, get("/active_admin_themes/density-compact.css")[0]
  end

  private

  def get(path)
    ActiveAdmin::Themes::Middleware.new(APP).call("PATH_INFO" => path)
  end
end
