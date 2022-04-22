# frozen_string_literal: true

class Explanation < ApplicationRecord
  belongs_to :worker
  belongs_to :hit
end
