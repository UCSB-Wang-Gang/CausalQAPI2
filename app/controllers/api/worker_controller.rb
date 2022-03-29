# frozen_string_literal: true

module Api
  # Controller for Workers
  class WorkerController < ApplicationController
    def reset_last_check
      worker = Worker.find_by(worker_id: worker_params[:worker_id])
      if worker.present?
        worker.submissions_since_check = 0
        worker.save
        render json: worker
      else
        render json: { error: 'Worker not found' }, status: :not_found
      end
    end

    def review_top_k
      workers = Worker.order(params['criteria'] + " DESC").limit(params['num_workers'])
      if workers.present?
        render json: workers
      else
        render json: { error: 'review_top_k error' }
      end
    end

    private

    def worker_params
      params.require(:worker).permit(:worker_id)
    end
  end
end
