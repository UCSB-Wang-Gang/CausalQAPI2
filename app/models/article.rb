# frozen_string_literal: true

class Article < ApplicationRecord
  has_many :hits, dependent: :delete_all
  has_many :passages, dependent: :delete_all
end
