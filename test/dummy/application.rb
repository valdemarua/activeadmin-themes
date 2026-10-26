# frozen_string_literal: true

# A small ActiveAdmin app, booted the way a real app boots, with the theme from
# ENV["THEME"] ("none" for no theme). ActiveAdmin's CSS comes from activeadmin_assets.
ENV["RAILS_ENV"] = "test"
ENV["DATABASE_URL"] = "sqlite3::memory:"

require "rails"
require "active_record/railtie"
require "action_controller/railtie"
require "active_admin"
require "activeadmin_assets"
require "activeadmin-themes"

class Dummy < Rails::Application
  config.load_defaults Rails::VERSION::STRING.to_f
  config.root = __dir__
  config.eager_load = false
  config.logger = Logger.new(nil)
  config.secret_key_base = "test"
  config.active_support.deprecation = :raise
  config.action_dispatch.show_exceptions = :none
end

Dummy.initialize!

ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define do
  create_table :products do |t|
    t.string :name
    t.string :status
    t.decimal :price
    t.timestamps
  end
end
