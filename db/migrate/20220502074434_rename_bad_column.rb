# frozen_string_literal: true

# Rename bad explanation column
class RenameBadColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :workers, :explanation_since_check, :explanations_since_check
  end
end
