# frozen_string_literal: true

module ActiveAdmin
  module Themes
    # Serves /active_admin_themes/<version>/<theme>.css: the theme's CSS files
    # concatenated, straight from the gem. No asset pipeline involved.
    class Middleware
      ASSETS = File.join(__dir__, "assets")

      def initialize(app)
        @app = app
      end

      def call(env)
        path = env["PATH_INFO"]
        return @app.call(env) unless path.start_with?("/active_admin_themes/")

        name = path[%r{\A/active_admin_themes/[^/]+/(\w+)\.css\z}, 1]
        return [404, { "content-type" => "text/plain" }, ["Not found"]] unless name && THEMES.key?(name.to_sym)

        # Cached for a year: the href carries ?v=<digest of the CSS>.
        [200, { "content-type" => "text/css; charset=utf-8", "cache-control" => "public, max-age=31536000, immutable" },
         [Themes.css(name.to_sym)]]
      end
    end
  end
end
