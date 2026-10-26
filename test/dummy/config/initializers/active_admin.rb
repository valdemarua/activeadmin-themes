# frozen_string_literal: true

ActiveAdmin.setup do |config|
  config.site_title = "Dummy"
  config.authentication_method = false
  config.current_user_method = false
  config.comments = false
  config.batch_actions = true
end

ActiveAdmin::Themes.use ENV.fetch("THEME") unless ENV.fetch("THEME", "none") == "none"
