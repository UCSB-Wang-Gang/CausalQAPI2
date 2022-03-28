# frozen_string_literal: true

# Add default values for submissions
class AddDefaultValueHits < ActiveRecord::Migration[6.1]
  def change
    change_column :workers, :submissions, :integer, default: 0
    change_column :workers, :submissions_since_check, :integer, default: 0
  end
end
