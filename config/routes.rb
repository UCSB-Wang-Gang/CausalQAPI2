# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    post '/add_hit', action: :add_hit, controller: :hit

    post '/reset_last_check', action: :reset_last_check, controller: :worker
  end
end
