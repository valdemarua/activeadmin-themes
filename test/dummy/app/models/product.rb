# frozen_string_literal: true

class Product < ActiveRecord::Base
  def self.ransackable_attributes(_auth = nil) = %w[name status price created_at]
  def self.ransackable_associations(_auth = nil) = []
end
