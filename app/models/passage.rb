# frozen_string_literal: true

class Passage < ApplicationRecord
  belongs_to :article
  has_many :patterns, dependent: :delete_all
end
