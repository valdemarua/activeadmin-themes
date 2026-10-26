# frozen_string_literal: true

ActiveAdmin.register Product do
  menu parent: "Catalog"

  scope :all, default: true
  scope(:active) { |products| products.where(status: "active") }

  filter :name
  filter :status
  filter :price

  index do
    selectable_column
    id_column
    column :name
    column :status
    column :price
    actions
  end
end
