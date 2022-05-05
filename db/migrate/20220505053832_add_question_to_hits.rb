# frozen_string_literal: true

# add question column to hits table
class AddQuestionToHits < ActiveRecord::Migration[6.1]
  def change
    add_column :hits, :question, :string
  end
end
