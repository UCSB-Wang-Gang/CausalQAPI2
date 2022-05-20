# frozen_string_literal: true

class Validator < ApplicationRecord
  has_many :hits
  has_many :explanations
end
