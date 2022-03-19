# frozen_string_literal: true

# Add foreign key references
class AddTableReferences < ActiveRecord::Migration[6.1]
  def change
    add_reference :hits, :worker, foreign_key: true
    add_reference :hits, :article, foreign_key: true

    add_reference :passages, :article, foreign_key: true

    add_reference :patterns, :passage, foreign_key: true
  end
end
