# frozen_string_literal: true

module Api
  # Controller for Workers
  class WorkerController < ApplicationController
    def reset_last_hits_check
      worker = Worker.find_by(worker_id: params[:worker_id])
      if worker.present?
        worker.hits_since_check = 0
        worker.save
        render json: worker
      else
        render json: { error: 'Worker not found' }, status: :not_found
      end
    end

    def reset_last_explanations_check
      worker = Worker.find_by(worker_id: params[:worker_id])
      if worker.present?
        worker.explanations_since_check = 0
        worker.save
        render json: worker
      else
        render json: { error: 'Worker not found' }, status: :not_found
      end
    end

    def review_top_k
      workers = Worker
                .order("#{params['criteria']} DESC")
                .limit(params['num_workers'])
      if workers.present?
        render json: workers
      else
        render json: { error: 'review_top_k error' }
      end
    end

    def speed_bumped
      workers = Worker
                .where(checked_status: 'limited')
      render json: workers
    end

    def bumped2
      workers = Worker
                .where(bump2: 'limited')
      render json: workers
    end

    def qualify_worker
      worker = Worker.find_by(worker_id: params[:worker_id])
      worker = Worker.create(worker_id: params[:worker_id]) unless worker.present?
      worker.qualified = true
      worker.quiz_attempts = params[:quiz_attempts]
      worker.save
      render json: worker
    end

    def worker_qualification
      worker = Worker.find_by(worker_id: params[:worker_id])
      return render json: { qualified: false, error: 'Worker not found' }, status: :not_found unless worker.present?

      render json: { qualified: worker.qualified }
    end

    def update_checked_status
      worker = Worker.find_by(worker_id: params[:worker_id])
      if params[:stage_num] == '1'
        worker.checked_status = params[:new_status]
      else
        worker.bump2 = params[:new_status]
      end
      worker.save
      render json: worker
    end

    def grab_worker
      worker = Worker.find_by(worker_id: params[:worker_id])
      worker = Worker.create(worker_id: params[:worker_id]) unless worker.present?
      worker.save

      render json: { worker_info: worker }
    end

    def reset_worker_hit_count
      worker = Worker.find_by(worker_id: params[:worker_id])
      worker.hit_submits = 0
      worker.hits_since_check = 0
      worker.bad_s1_count = 0
      worker.good_s1_count = 0
      worker.save
      render json: worker
    end

    def reset_top_worker_hit_count
      worker = Worker.find_by_sql('SELECT * FROM workers
        ORDER BY (hit_submits - good_s1_count - bad_s1_count) DESC').first
      worker.hit_submits = 0
      worker.hits_since_check = 0
      worker.bad_s1_count = 0
      worker.good_s1_count = 0
      worker.save
      render json: worker
    end
  end
end
