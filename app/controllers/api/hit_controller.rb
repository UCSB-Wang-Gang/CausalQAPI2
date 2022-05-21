# frozen_string_literal: true

module Api
  # Controller for HITs
  class HitController < ApplicationController
    def add_hit
      worker = Worker.find_by(worker_id: hit_params[:worker_id])
      return render json: { error: 'worker not found' } unless worker.present?
      return render json: { error: 'assignment_id already exists' } if matched_ass

      # remove passage on submit
      handle_passage_delete(hit_params[:passage_id])

      hit = create_hit(worker, create_article(hit_params[:article]))
      increase_submission_count(worker)
      render json: hit
    end

    def worker_hits
      worker = Worker.find_by(worker_id: params[:worker_id])
      return render json: { error: 'worker not found' } unless worker.present?

      hits = Hit.where(worker_id: worker.id)
      if hits.present?
        render json: hits
      else
        render json: { error: 'no hits associated with worker_id' }, status: :not_found
      end
    end

    def return_hit
      hit = hit_getter_helper(params[:eval_status])
      return render json: { error: 'no hits found' }, status: :not_found unless hit.present?

      result = { hit: hit, article: Article.find(hit.article_id) }
      result[:worker] = Worker.find(hit.worker_id) if params.key?(:show_worker_stats)
      render json: result
    end

    def s1_get_by_worker_unmarked
      # choose random hit from worker with most unmarked hits
      worker = Worker.find_by_sql("
        SELECT * FROM workers ORDER BY (hit_submits - good_s1_count - bad_s1_count) DESC
      ").first
      hit = Hit.where(worker_id: worker.id, eval: nil).sample
      return render json: { error: 'no unevaluated hit' } unless hit.present?

      render json: {
        hit: hit,
        article: Article.find(hit.article_id),
        worker: worker
      }
    end

    def return_s1_info
      render json: {
        total: Hit.all.count,
        no_exp: Hit.where.missing(:explanation).count,
        good: Hit.where(eval: 'good').count,
        bad: Hit.where(eval: 'bad').count,
        good_no_exp: Hit.where(eval: 'good').where.missing(:explanation).count,
        total_eval: Hit.where.not(eval: nil).count
      }
    end

    def update_hit_eval
      hit = Hit.find_by(id: params[:hit_id])
      return render json: { error: 'hit not found' } unless hit.present?

      update_worker_s1_counts(hit.worker_id, hit.eval, params[:new_eval_field], 1)
      render json: evaluate_hit(hit, params[:new_eval_field], hit_params[:validator_username])
    end

    def eval_all_s1_by
      hits = Hit.where(worker_id: params[:worker_id], eval: nil)
      num = hits.count
      hits.update_all(eval: params[:new_status])
      update_worker_s1_counts(params[:worker_id], nil, params[:new_status], num)
      render json: { num_eval: num }
    end

    def edit_s1_hit
      hit = Hit.find_by(id: hit_params[:id])
      hit.cause = hit_params[:cause] if hit_params[:cause].present?
      hit.effect = hit_params[:effect] if hit_params[:effect].present?
      hit.question = hit_params[:question] if hit_params[:question].present?
      hit.save
      render json: hit
    end

    private

    def evaluate_hit(hit, eval_status, validator_username)
      hit.eval = eval_status
      validator = Validator.find_by(username: validator_username)
      validator = Validator.create(username: validator_username, count: 0) unless validator.present?

      validator.count = validator.count + 1
      validator.save

      hit.validator_id = validator.id
      hit.save

      hit
    end

    def hit_getter_helper(eval_status)
      candidates = Hit.where.missing(:explanation)
      candidates = candidates.where(eval: eval_status == 'null' ? nil : eval_status)
      candidates.sample
    end

    def update_worker_s1_counts(worker_id, old_eval, new_eval, amt)
      worker = Worker.find_by(id: worker_id)
      return unless worker.present? && amt.positive?

      worker["#{old_eval}_s1_count"] = worker["#{old_eval}_s1_count"] - amt if old_eval.present?
      worker["#{new_eval}_s1_count"] = worker["#{new_eval}_s1_count"] + amt
      worker.save
    end

    def handle_passage_delete(pass_id)
      puts pass_id
      passage = Passage.find_by(id: pass_id)
      Passage.destroy(pass_id) if passage.present?
    end

    def matched_ass
      Hit.where(assignment_id: hit_params[:assignment_id]).present?
    end

    def hit_params
      params.require(:hit).permit(:assignment_id, :worker_id, :id, :article, :passage,
                                  :cause, :effect, :question, :passage_id, :validator_username)
    end

    def create_article(article_title)
      article = Article.find_by(title: article_title)
      article = Article.create(title: article_title) unless article.present?
      article
    end

    def create_hit(worker, article)
      Hit.create(
        worker_id: worker.id,
        article_id: article.id,
        assignment_id: hit_params[:assignment_id],
        passage: hit_params[:passage],
        cause: hit_params[:cause],
        effect: hit_params[:effect],
        question: hit_params[:question]
      )
    end

    def increase_submission_count(worker)
      worker.hit_submits = worker.hit_submits + 1
      worker.checked_status = 'limited' if (worker.hit_submits >= 20) && (worker.checked_status == 'unchecked')
      worker.hits_since_check = worker.hits_since_check + 1
      worker.save
    end
  end
end
