# frozen_string_literal: true

require "digest"
require_relative "themes/version"
require_relative "themes/config"
require_relative "themes/middleware"
require_relative "themes/railtie" if defined?(Rails::Railtie)

module ActiveAdmin
  # Configurable layout and density for ActiveAdmin 4:
  #
  #   ActiveAdmin::Themes.configure do |c|
  #     c.navigation = :top       # :sidebar
  #     c.density    = :compact   # :default
  #     c.scopes     = :chips     # :default
  #     c.style      = :classic   # :default
  #   end
  #
  #   ActiveAdmin::Themes.use :compact   # or :classic, a preset of the above
  #
  # Each setting that differs from ActiveAdmin's default adds plain CSS, loaded
  # after AA's stylesheet (so it works with activeadmin_assets or an app's own
  # Tailwind build). navigation: :top also swaps in a few partials.
  module Themes
    ROOT = File.expand_path("../..", __dir__)

    class << self
      def config = @config ||= Config.new

      def configure
        yield config
      end

      # Applies a preset. Settings it doesn't name go back to their defaults.
      def use(preset)
        settings = PRESETS.fetch(preset.to_sym) do
          raise ArgumentError, "unknown preset #{preset.to_sym.inspect} (#{PRESETS.keys.join(", ")})"
        end
        @config = Config.new
        settings.each { |name, value| config.public_send(:"#{name}=", value) }
      end

      # Back to ActiveAdmin's defaults.
      def reset!
        @config = nil
      end

      def path = "/active_admin_themes/#{VERSION}"

      # nil when every setting is ActiveAdmin's default. The URL names the
      # stylesheets and carries a digest of their CSS, so the long cache the
      # middleware sends is busted whenever the CSS changes.
      def stylesheet_href
        names = config.stylesheets
        "#{path}/#{names.join("+")}.css?v=#{digest(names)}" if names.any?
      end

      def css(names = config.stylesheets)
        names.map { |name| File.read(File.join(Middleware::ASSETS, "#{name}.css")) }.join("\n")
      end

      def digest(names = config.stylesheets) = Digest::SHA256.hexdigest(css(names))[0, 12]

      # The gem's partials for ActiveAdmin's controllers, most specific first.
      # None when every setting is ActiveAdmin's default.
      def view_paths
        return [] if config.stylesheets.empty?

        dirs = config.navigation == :top ? %w[top base] : %w[base]
        dirs.map { |dir| File.join(ROOT, "app/views/active_admin_themes", dir) }
      end
    end
  end
end
