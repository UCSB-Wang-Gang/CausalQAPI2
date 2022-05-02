# frozen_string_literal: true

module Api
  # Controller for stage 2 explanations
  class ExplanationController < ApplicationController
    def add_explanation
      worker = Worker.find_by(worker_id: explanation_params[:worker_id])
      return render json: { error: 'worker not found' } unless worker.present?
      return render json: { error: 'assignment_id already exists' } if matched_ass

      explanation = create_explanation(worker)
      increase_submission_count(worker)
      render json: explanation
    end

    def worker_explanations
      worker = Worker.find_by(worker_id: params[:worker_id])
      return render json: { error: 'worker not found' } unless worker.present?

      explanations = Explanation.where(worker_id: worker.id)
      if explanations.present?
        render json: explanations
      else
        render json: { error: 'no explanations associated with worker_id' }, status: :not_found
      end
    end

    private

    def increase_submission_count(worker)
      worker.explanation_submits = worker.explanation_submits + 1
      worker.checked_status = 'limited' if (worker.explanation_submits >= 20) && (worker.checked_status == 'unchecked')
      worker.explanations_since_check = worker.explanations_since_check + 1
      worker.save
    end

    def create_explanation(worker)
      Explanation.create(
        worker_id: worker.id,
        hit_id: explanation_params[:hit_id],
        assignment_id: explanation_params[:assignment_id],
        explanation: explanation_params[:explanation]
      )
    end

    def explanation_params
      params.require(:explanation).permit(:explanation, :worker_id, :hit_id, :assignment_id)
    end
  end
end
