# frozen_string_literal: true

require "digest"
require_relative "themes/version"
require_relative "themes/middleware"
require_relative "themes/railtie" if defined?(Rails::Railtie)

module ActiveAdmin
  # Alternative looks for ActiveAdmin 4, layered on top of AA's own CSS:
  #
  #   ActiveAdmin::Themes.use :compact   # AA 4 layout, denser
  #   ActiveAdmin::Themes.use :classic   # top menu like AA 1-3, denser
  #
  # A theme is plain CSS loaded after AA's stylesheet (so it works with
  # activeadmin_assets or an app's own Tailwind build) plus, for :classic,
  # a few partial overrides.
  module Themes
    THEMES = {
      compact: {stylesheets: %w[compact], views: %w[base]},
      classic: {stylesheets: %w[compact classic], views: %w[classic base]}
    }.freeze

    ROOT = File.expand_path("../..", __dir__)

    class << self
      attr_reader :theme

      def use(name)
        name = name.to_sym
        raise ArgumentError, "unknown ActiveAdmin theme #{name.inspect} (#{THEMES.keys.join(", ")})" unless THEMES.key?(name)

        @theme = name
      end

      def path = "/active_admin_themes/#{VERSION}"

      # The URL carries a digest of the theme's CSS, so the long cache the
      # middleware sends is busted whenever the CSS changes (gem update, or
      # editing it in development).
      def stylesheet_href
        theme && "#{path}/#{theme}.css?v=#{digest}"
      end

      def stylesheets = THEMES.fetch(theme)[:stylesheets]

      def css(name = theme)
        THEMES.fetch(name)[:stylesheets].map { File.read(File.join(Middleware::ASSETS, "#{it}.css")) }.join("\n")
      end

      def digest = Digest::SHA256.hexdigest(css)[0, 12]

      # Most specific first: classic's partials, then the shared ones.
      def view_paths
        return [] unless theme

        THEMES.fetch(theme)[:views].map { File.join(ROOT, "app/views/active_admin_themes", it) }
      end
    end
  end
end
