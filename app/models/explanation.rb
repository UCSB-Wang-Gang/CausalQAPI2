# frozen_string_literal: true

class Explanation < ApplicationRecord
  belongs_to :validator, optional: true
  belongs_to :worker
  belongs_to :hit
end
