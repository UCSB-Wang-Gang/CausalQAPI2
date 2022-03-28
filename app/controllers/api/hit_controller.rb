# frozen_string_literal: true

module Api
  # Controller for HITs
  class HitController < ApplicationController
    def add_hit
      worker = create_worker(hit_params[:worker_id])
      article = create_article(hit_params[:article])
      hit = create_hit(worker, article)
      increase_submission_count(worker)
      render json: hit
    end

    private

    def hit_params
      params.require(:hit).permit(:assignment_id, :worker_id, :question, :answer, :article, :explanation)
    end

    def create_worker(worker_id)
      worker = Worker.find_by(worker_id: worker_id)
      worker = Worker.create(worker_id: worker_id) unless worker.present?
      worker
    end

    def create_article(article_title)
      article = Article.find_by(title: article_title)
      article = Article.create(title: article_title) unless article.present?
      article
    end

    def create_hit(worker, article)
      Hit.create(
        assignment_id: hit_params[:assignment_id],
        worker_id: worker.id,
        question: hit_params[:question],
        answer: hit_params[:answer],
        article_id: article.id,
        explanation: hit_params[:explanation]
      )
    end

    def increase_submission_count(worker)
      worker.submissions = worker.submissions + 1
      worker.submissions_since_check = worker.submissions_since_check + 1
      worker.save
    end
  end
end
