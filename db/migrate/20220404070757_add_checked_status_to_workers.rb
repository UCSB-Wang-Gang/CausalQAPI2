# frozen_string_literal: true

# This adds the checkedd_status column for validation reasons
class AddCheckedStatusToWorkers < ActiveRecord::Migration[6.1]
  def change
    add_column :workers, :checked_status, :string, default: 'unchecked'
  end
end
