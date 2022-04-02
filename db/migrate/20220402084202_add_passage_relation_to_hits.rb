# frozen_string_literal: true

# Relates hit to passage instead of article
class AddPassageRelationToHits < ActiveRecord::Migration[6.1]
  def change
    add_column :hits, :cause, :string
    add_column :hits, :effect, :string
    add_column :hits, :passage, :string
  end
end
