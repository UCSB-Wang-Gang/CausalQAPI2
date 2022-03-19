# frozen_string_literal: true

class Worker < ApplicationRecord
  has_many :hits, dependent: :delete_all
end
