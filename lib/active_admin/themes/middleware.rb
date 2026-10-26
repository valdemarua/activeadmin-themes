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
        theme = name && THEMES[name.to_sym]
        return [404, {"content-type" => "text/plain"}, ["Not found"]] unless theme

        css = theme[:stylesheets].map { File.read(File.join(ASSETS, "#{it}.css")) }.join("\n")
        [200, {"content-type" => "text/css; charset=utf-8", "cache-control" => "public, max-age=31536000, immutable"}, [css]]
      end
    end
  end
end
