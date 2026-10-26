# frozen_string_literal: true

require_relative "lib/active_admin/themes/version"

Gem::Specification.new do |spec|
  spec.name = "activeadmin-themes"
  spec.version = ActiveAdmin::Themes::VERSION
  spec.authors = ["valdemarua"]

  spec.summary = "Configurable layout and density for ActiveAdmin 4."
  spec.description = "Sidebar or top navigation, compact sizing and compact scopes for ActiveAdmin 4. " \
                     "Plain CSS and a few view overrides layered on ActiveAdmin, with no fork and no CSS build. " \
                     "Works with or without activeadmin_assets."
  spec.homepage = "https://github.com/valdemarua/activeadmin-themes"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "changelog_uri" => "#{spec.homepage}/blob/main/CHANGELOG.md",
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir["lib/**/*", "app/**/*", "README.md", "LICENSE", "CHANGELOG.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "activeadmin", ">= 4.0.0.beta", "< 5"
  spec.add_dependency "railties" # the Rails version comes from activeadmin
end
