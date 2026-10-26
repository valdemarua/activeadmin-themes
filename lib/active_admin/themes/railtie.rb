# frozen_string_literal: true

module ActiveAdmin
  module Themes
    # Serves the theme CSS and adds the theme views to ActiveAdmin.
    class Railtie < ::Rails::Railtie
      initializer "active_admin_themes.middleware" do |app|
        app.middleware.insert_before 0, Middleware
      end

      # Only ActiveAdmin's own controllers (admin pages and its Devise pages)
      # see the theme's partials; the rest of the app is untouched.
      config.to_prepare do
        next unless ActiveAdmin::Themes.theme

        controllers = [ActiveAdmin::BaseController]
        # ActiveAdmin's Devise controllers raise on load in apps without Devise.
        if defined?(::Devise)
          controllers += %w[Sessions Passwords Unlocks Registrations Confirmations]
                         .filter_map { |name| "ActiveAdmin::Devise::#{name}Controller".safe_constantize }
        end
        controllers.each do |controller|
          ActiveAdmin::Themes.view_paths.reverse_each { |path| controller.prepend_view_path(path) }
        end
      end
    end
  end
end
