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
      hit = Hit.where.missing(:explanation).order(Arel.sql('RANDOM()')).first
      return render json: { error: 'no hits found' }, status: :not_found unless hit.present?

      render json: hit
    end

    private

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
                                  :cause, :effect, :passage_id)
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
        effect: hit_params[:effect]
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
