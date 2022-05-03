# Change column data type for workers
class ChangeWorkerColumns < ActiveRecord::Migration[6.1]
  def change
    change_column :workers, :explanation_submits, :integer, using: 0
    change_column :workers, :explanations_since_check, :integer, using: 0
  end
end
