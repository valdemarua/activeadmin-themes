# frozen_string_literal: true

module ActiveAdmin
  module Themes
    # Serves /active_admin_themes/<version>/<names>.css, e.g.
    # density-compact+navigation-top.css: those stylesheets concatenated,
    # straight from the gem. No asset pipeline involved.
    class Middleware
      ASSETS = File.join(__dir__, "assets")
      HEADERS = {
        "content-type" => "text/css; charset=utf-8",
        # Cached for a year: the href carries ?v=<digest of the CSS>.
        "cache-control" => "public, max-age=31536000, immutable"
      }.freeze

      def initialize(app)
        @app = app
      end

      def call(env)
        path = env["PATH_INFO"]
        return @app.call(env) unless path.start_with?("/active_admin_themes/")

        names = path[%r{\A/active_admin_themes/[^/]+/([a-z+-]+)\.css\z}, 1]&.split("+")
        unless names&.any? && (names - STYLESHEETS).empty?
          return [404, { "content-type" => "text/plain" },
                  ["Not found"]]
        end

        [200, HEADERS.dup, [Themes.css(names)]]
      end
    end
  end
end
