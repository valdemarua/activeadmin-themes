# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create(:test) do |t|
  t.test_globs = ["test/active_admin/**/*_test.rb"]
end

# The dummy app reads its theme once at boot, so each setting runs in its own process.
THEMES = %w[none compact classic].freeze

THEMES.each do |theme|
  Minitest::TestTask.create(:"test:integration:#{theme}") do |t|
    t.test_globs = ["test/integration/**/*_test.rb"]
    t.test_prelude = %(ENV["THEME"] = "#{theme}")
    t.warning = false # ActiveAdmin itself is not -w clean
  end
end

desc "Run the integration tests for every theme"
task "test:integration" => THEMES.map { |theme| "test:integration:#{theme}" }

begin
  require "rubocop/rake_task"
  RuboCop::RakeTask.new
rescue LoadError
  # RuboCop is not part of the Rails gemfiles.
end

task default: %i[test test:integration rubocop]
