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

      render json: Worker.connection.execute("
        SELECT
          exp.explanation, exp.assignment_id, exp.hit_id, exp.worker_id,
          hits.cause, hits.effect, hits.passage
        FROM explanations AS exp
        INNER JOIN hits ON exp.hit_id = hits.id
        WHERE exp.worker_id = '#{worker.id}';
      ")
    end

    def s2_get_by_worker_unmarked
      worker = Worker.find_by_sql("
        SELECT * FROM workers ORDER BY (explanation_submits - good_s2_count - bad_s2_count) DESC
      ").first
      explanation = Explanation.where(worker_id: worker.id, eval: nil).sample
      hit = Hit.find(explanation.hit_id)
      return render json: { error: 'no unevaluated explanations' } unless explanation.present?

      render json: {
        explanation: explanation,
        hit: hit,
        article: Article.find(hit.article_id),
        worker: worker
      }
    end

    def update_explanation_eval
      explanation = Explanation.find_by(id: params[:explanation_id])
      return render json: { error: 'explanation not found' } unless explanation.present?

      update_worker_s2_counts(explanation.worker_id, explanation.eval, params[:new_eval_field], 1)
      render json: evaluate_explanation(explanation, params[:new_eval_field], explanation_params[:validator_username])
    end

    def eval_all_s2_by
      explanations = Explanation.where(worker_id: params[:worker_id], eval: nil)
      num = explanations.count
      explanations.update_all(eval: params[:new_status])
      update_worker_s2_counts(params[:worker_id], nil, params[:new_status], num)
      Explanation.destroy_all(eval: 'bad') if params[:new_status] == 'bad'
      render json: { num_eval: num }
    end

    def edit_s2_exp
      explanation = Explanation.find_by(id: explanation_params[:id])
      explanation.explanation = explanation_params[:explanation]
      explanation.save
      hit = Hit.find_by(id: explanation.hit_id)
      hit.cause = explanation_params[:cause]
      hit.effect = explanation_params[:effect]
      hit.save
    end

    def exp_metrics
      render json: {
        total_exp: Explanation.all.count,
        missing_exp: Hit.where(eval: 'good').where.missing(:explanation).count,
        good: Explanation.where(eval: 'good').count,
        bad: Explanation.where(eval: 'bad').count,
        total_eval: Explanation.where.not(eval: nil).count
      }
    end

    private

    def evaluate_explanation(explanation, eval_status, validator_username)
      explanation.eval = eval_status
      validator = Validator.find_by(username: validator_username)
      validator = Validator.create(username: validator_username, count: 0) unless validator.present?

      validator.count = validator.count + 1
      validator.save

      explanation.validator_id = validator.id
      explanation.save

      if eval_status == 'bad'
        Explanation.destroy(explanation.id)
        'deleted explanation'
      else
        explanation
      end
    end

    def update_worker_s2_counts(worker_id, old_eval, new_eval, amt)
      worker = Worker.find_by(id: worker_id)
      return unless worker.present? && amt.positive?

      if new_eval == 'ok'
        new_eval = 'good'
      end 

      worker["#{old_eval}_s2_count"] = worker["#{old_eval}_s2_count"] - amt if old_eval.present?
      worker["#{new_eval}_s2_count"] = worker["#{new_eval}_s2_count"] + amt
      worker.save
    end

    def increase_submission_count(worker)
      worker.explanation_submits = worker.explanation_submits + 1
      worker.bump2 = 'limited' if (worker.explanation_submits >= 20) && (worker.bump2 == 'unchecked')
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

    def matched_ass
      Explanation.where(assignment_id: explanation_params[:assignment_id]).present?
    end

    def explanation_params
      params.require(:explanation).permit(:id, :explanation, :worker_id, :hit_id, :assignment_id, :validator_username,
                                          :cause, :effect)
    end
  end
end
