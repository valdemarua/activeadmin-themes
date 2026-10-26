# frozen_string_literal: true

Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  get "plain", to: "plain#show"
end
