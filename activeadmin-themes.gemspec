# frozen_string_literal: true

require_relative "lib/active_admin/themes/version"

Gem::Specification.new do |spec|
  spec.name = "activeadmin-themes"
  spec.version = ActiveAdmin::Themes::VERSION
  spec.summary = "Alternative themes for ActiveAdmin 4: Compact and Classic"
  spec.authors = ["valdemarua"]
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3"
  spec.files = Dir["lib/**/*", "app/**/*", "README.md", "LICENSE"]

  spec.add_dependency "activeadmin", ">= 4.0.0.beta", "< 5"
  spec.add_dependency "railties", ">= 7.1"
end
