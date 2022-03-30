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
      workers = Worker.order("#{params['criteria']} DESC").limit(params['num_workers'])
      if workers.present?
        render json: workers
      else
        render json: { error: 'review_top_k error' }
      end
    end

    def qualify_worker
      client = Aws::MTurk::Client.new(region: 'us-east-1')
      worker = create_worker(worker_params[:worker_id])
      return render json: { error: 'Worker already exists' } if worker.present?

      render json: client.associate_qualification_with_worker({
                                                                qualification_type_id: 'EntityId',
                                                                worker_id: worker.worker_id,
                                                                integer_value: 1,
                                                                send_notification: false
                                                              })
    end

    private

    def worker_params
      params.require(:worker).permit(:worker_id)
    end

    def create_worker(worker_id)
      worker = Worker.find_by(worker_id: worker_id)
      worker = Worker.create(worker_id: worker_id) unless worker.present?
      worker
    end
  end
end
