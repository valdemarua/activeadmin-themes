# frozen_string_literal: true

# A page outside ActiveAdmin: themes must not touch it.
class PlainController < ApplicationController
  def show
    render plain: view_paths.to_a.join("\n")
  end
end
