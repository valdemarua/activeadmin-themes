# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create(:test) do |t|
  t.test_globs = ["test/active_admin/**/*_test.rb"]
end

# The dummy app reads its settings once at boot, so each combination runs in its
# own process: no settings, both presets, and the top menu in ActiveAdmin's colors.
THEMES = {
  none: "none",
  compact: "compact",
  classic: "classic",
  top: "navigation=top,density=compact,scopes=chips"
}.freeze

THEMES.each do |name, theme|
  Minitest::TestTask.create(:"test:integration:#{name}") do |t|
    t.test_globs = ["test/integration/**/*_test.rb"]
    t.test_prelude = %(ENV["THEME"] = "#{theme}")
    t.warning = false # ActiveAdmin itself is not -w clean
  end
end

desc "Run the integration tests for every theme"
task "test:integration" => THEMES.keys.map { |name| "test:integration:#{name}" }

begin
  require "rubocop/rake_task"
  RuboCop::RakeTask.new
rescue LoadError
  # RuboCop is not part of the Rails gemfiles.
end

task default: %i[test test:integration rubocop]
