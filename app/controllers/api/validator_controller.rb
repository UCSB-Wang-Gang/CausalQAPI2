# frozen_string_literal: true

module Api
  # Controller for Validators
  class ValidatorController < ApplicationController
    def leaderboard
      validators = Validator
                   .order('count DESC')

      if validators.present?
        render json: validators
      else
        render json: {}
      end
    end
  end
end
