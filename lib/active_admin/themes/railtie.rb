# frozen_string_literal: true

module ActiveAdmin
  module Themes
    class Railtie < ::Rails::Railtie
      initializer "active_admin_themes.middleware" do |app|
        app.middleware.insert_before 0, Middleware
      end

      # Only ActiveAdmin's own controllers (admin pages and its Devise pages)
      # see the theme's partials; the rest of the app is untouched.
      config.to_prepare do
        next unless ActiveAdmin::Themes.theme

        controllers = [ActiveAdmin::BaseController]
        controllers += %w[Sessions Passwords Unlocks Registrations Confirmations]
          .filter_map { "ActiveAdmin::Devise::#{it}Controller".safe_constantize }
        controllers.each do |controller|
          ActiveAdmin::Themes.view_paths.reverse_each { controller.prepend_view_path(it) }
        end
      end
    end
  end
end
