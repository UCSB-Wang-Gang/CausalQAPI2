# frozen_string_literal: true

# Add columns for stage 2 validations
class AddS2Validations < ActiveRecord::Migration[6.1]
  def change
    add_column :explanations, :eval, :string, default: nil
    add_column :workers, :good_s2_count, :integer, default: 0
    add_column :workers, :bad_s2_count, :integer, default: 0
  end
end
