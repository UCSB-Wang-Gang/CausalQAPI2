# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    post '/add_hit', action: :add_hit, controller: :hit
    get '/get_hits/:worker_id', action: :worker_hits, controller: :hit

    post '/reset_last_check', action: :reset_last_check, controller: :worker
    get '/get_top_k/:num_workers/:criteria', action: :review_top_k, controller: :worker

    post '/add_passage', action: :add_passage, controller: :passage
    get '/get_passage', action: :return_passage, controller: :passage
  end
end
