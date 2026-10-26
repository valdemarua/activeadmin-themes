# frozen_string_literal: true

module ActiveAdmin
  module Themes
    # The settings, each with its allowed values. The first value is the default,
    # which is always ActiveAdmin's own behavior.
    SETTINGS = {
      navigation: %i[sidebar top],
      density: %i[default compact],
      scopes: %i[default chips],
      style: %i[default classic]
    }.freeze

    # One stylesheet per non-default value: "density-compact", "navigation-top", ...
    STYLESHEETS = SETTINGS.flat_map { |name, values| values.drop(1).map { |value| "#{name}-#{value}" } }.freeze

    # Named combinations of settings, for `ActiveAdmin::Themes.use`.
    PRESETS = {
      compact: { density: :compact, scopes: :chips },
      classic: { navigation: :top, density: :compact, scopes: :chips, style: :classic }
    }.freeze

    # The current settings. Values are validated on assignment.
    class Config
      SETTINGS.each do |name, values|
        attr_reader name

        define_method(:"#{name}=") do |value|
          value = value.to_sym
          unless values.include?(value)
            raise ArgumentError, "unknown #{name} #{value.inspect} (#{values.map(&:inspect).join(", ")})"
          end

          instance_variable_set(:"@#{name}", value)
        end
      end

      def initialize
        SETTINGS.each { |name, values| instance_variable_set(:"@#{name}", values.first) }
      end

      def to_h = SETTINGS.keys.to_h { |name| [name, public_send(name)] }

      # The settings that differ from ActiveAdmin's defaults, as stylesheet names
      # ("density-compact"), in the order their CSS loads.
      def stylesheets
        SETTINGS.filter_map { |name, values| "#{name}-#{public_send(name)}" unless public_send(name) == values.first }
      end
    end
  end
end
