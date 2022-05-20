# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    get '/get_hits/:worker_id', action: :worker_hits, controller: :hit
    get '/get_hit/:eval_status(/:show_worker_stats)', action: :return_hit, controller: :hit
    get '/get_hit_metrics', action: :return_s1_info, controller: :hit
    get '/get_s1_ordered', action: :s1_get_by_worker_unmarked, controller: :hit
    post '/add_hit', action: :add_hit, controller: :hit
    post '/eval_hit/:hit_id/:new_eval_field', action: :update_hit_eval, controller: :hit
    post '/eval_all_s1_by/:worker_id/:new_status', action: :eval_all_s1_by, controller: :hit

    get '/get_explanations/:worker_id', action: :worker_explanations, controller: :explanation
    post '/add_explanation', action: :add_explanation, controller: :explanation

    get '/get_top_k/:num_workers/:criteria', action: :review_top_k, controller: :worker
    get '/get_speed_bumped', action: :speed_bumped, controller: :worker
    get '/get_bumped2', action: :bumped2, controller: :worker
    get '/worker_qualification/:worker_id', action: :worker_qualification, controller: :worker
    get '/check_worker_info/:worker_id', action: :grab_worker, controller: :worker
    post '/reset_last_check/hits/:worker_id', action: :reset_last_hits_check, controller: :worker
    post '/reset_last_check/explanations/:worker_id', action: :reset_last_explanations_check, controller: :worker
    post '/qualify_worker/:worker_id/:quiz_attempts', action: :qualify_worker, controller: :worker
    post '/update_checked_status/:stage_num/:worker_id/:new_status', action: :update_checked_status, controller: :worker
    post '/reset_worker_hit_count/:worker_id', action: :reset_worker_hit_count, controller: :worker
    post '/reset_top_worker_hit_count', action: :reset_top_worker_hit_count, controller: :worker

    get '/get_passage', action: :return_passage, controller: :passage
    get '/count_passages', action: :count_passages, controller: :passage
    post '/add_passage', action: :add_passage, controller: :passage

    get '/leaderboard', action: :leaderboard, controller: :validator
  end
end
