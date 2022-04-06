# frozen_string_literal: true

module Api
  # Controller for passages
  class PassageController < ApplicationController
    def add_passage
      article = create_article(passage_params[:article])
      passage = Passage.create(
        article_id: article.id,
        passage: passage_params[:passage],
        patterns: passage_params[:patterns]
      )
      render json: passage
    end

    def return_passage
      passage = Passage.order(Arel.sql('RANDOM()')).first
      return render json: { error: 'no passages found' }, status: :not_found unless passage.present?

      passage.retrieved += 1
      passage.save

      article = Article.find(passage.article_id)
      render json: { passage: passage, article: article.title }

      # only remove passage if it has been retrieved a number of times
      Passage.destroy(passage.id) if passage.retrieved > 5
    end

    def count_passages
      render json: { num_passages: Passage.all.count }
    end

    private

    def passage_params
      params.require(:passage).permit(:passage, :article, :patterns)
    end

    def create_article(title)
      article = Article.find_by(title: title)
      article = Article.create(title: title) unless article.present?
      article
    end
  end
end
