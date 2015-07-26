class AddEpochBranchToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :epoch_branch, index: true
  end
end
