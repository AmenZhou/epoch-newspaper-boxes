class AddEpochIdToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :epoch_branch_id, :integer
  end
end
