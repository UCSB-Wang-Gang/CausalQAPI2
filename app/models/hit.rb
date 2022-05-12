# frozen_string_literal: true

class Hit < ApplicationRecord
  belongs_to :worker
  belongs_to :article
  belongs_to :validator, optional: true
  has_one :explanation, dependent: :destroy
end
