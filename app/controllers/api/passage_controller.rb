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
