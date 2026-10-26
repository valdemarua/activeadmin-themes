# frozen_string_literal: true

ActiveAdmin.setup do |config|
  config.site_title = "Dummy"
  config.authentication_method = false
  config.current_user_method = false
  config.comments = false
  config.batch_actions = true
end

# ENV["THEME"]: "none", a preset ("compact"), or settings ("navigation=top,density=compact").
theme = ENV.fetch("THEME", "none")
if ActiveAdmin::Themes::PRESETS.key?(theme.to_sym)
  ActiveAdmin::Themes.use theme
elsif theme != "none"
  ActiveAdmin::Themes.configure do |c|
    theme.split(",").each do |setting|
      name, value = setting.split("=")
      c.public_send(:"#{name}=", value)
    end
  end
end
