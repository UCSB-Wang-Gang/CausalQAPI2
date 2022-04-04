# frozen_string_literal: true

module Api
  # Controller for Workers
  class WorkerController < ApplicationController
    def reset_last_check
      worker = Worker.find_by(worker_id: params[:worker_id])
      if worker.present?
        worker.submissions_since_check = 0
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
      puts params[:worker_id]
      worker = Worker.find_by(worker_id: params[:worker_id])
      puts worker
      worker.checked_status = params[:new_status]
      worker.save
      render json: worker
    end
  end
end
