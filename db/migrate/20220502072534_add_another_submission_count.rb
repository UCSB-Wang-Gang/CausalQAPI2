# frozen_string_literal: true

# Adds second submission count
class AddAnotherSubmissionCount < ActiveRecord::Migration[6.1]
  def change
    rename_column :workers, :submissions, :hit_submits
    rename_column :workers, :submissions_since_check, :hits_since_check
    add_column :workers, :explanation_submits, :string
    add_column :workers, :explanation_since_check, :string
  end
end
