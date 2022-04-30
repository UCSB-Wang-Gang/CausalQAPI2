class AddFeedbackToWorkers < ActiveRecord::Migration[6.1]
  def change
    add_column :workers, :feedback, :string
  end
end
