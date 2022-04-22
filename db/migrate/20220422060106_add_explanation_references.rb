class AddExplanationReferences < ActiveRecord::Migration[6.1]
  def change
    add_column :explanations, :assignment_id, :string
    add_reference :explanations, :worker, foreign_key: true
    add_reference :explanations, :hit, foreign_key: true
  end
end
