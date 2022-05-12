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
      candidates = Hit.where.missing(:explanation)
      candidates = candidates.where(eval: params[:eval_status] == 'null' ? nil : params[:eval_status])
      hit = candidates.order(Arel.sql('RANDOM()')).first
      return render json: { error: 'no hits found' }, status: :not_found unless hit.present?

      render json: { hit: hit, article: Article.find(hit.article_id) }
    end

    def return_s1_info
      render json: {
        total: Hit.all.count,
        no_exp: Hit.where.missing(:explanation).count,
        good: Hit.where(eval: 'good').count,
        bad: Hit.where(eval: 'bad').count,
        total_eval: Hit.where.not(eval: nil).count
      }
    end

    def update_hit_eval
      hit = Hit.find_by(id: params[:hit_id])
      return render json: { error: 'hit not found' } unless hit.present?

      handle_bad_count_update(hit.worker_id, hit.eval, params[:new_eval_field])
      render json: evaluate_hit(hit, params[:new_eval_field], hit_params[:validator_username])
    end

    private

    def evaluate_hit(hit, eval_status, validator_username)
      hit.eval = eval_status
      validator = Validator.find_by(username: validator_username)
      Validator.create(username: validator_username, count: 0) unless validator.present?

      validator.count = validator.count + 1
      validator.save

      hit.validator_id = validator.id
      hit.save

      hit
    end

    def handle_bad_count_update(worker_id, old_eval, new_eval)
      worker = Worker.find_by(id: worker_id)
      return unless worker.present?

      if old_eval == 'bad' && new_eval != 'bad'
        worker.bad_s1_count = worker.bad_s1_count - 1
      elsif old_eval != 'bad' && new_eval == 'bad'
        worker.bad_s1_count = worker.bad_s1_count + 1
      end

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
      params.require(:hit).permit(:assignment_id, :worker_id, :article, :passage,
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
