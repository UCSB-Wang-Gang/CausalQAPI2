# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    post '/add_hit', action: :add_hit, controller: :hit
  end
end
