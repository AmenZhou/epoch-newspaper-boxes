class AddEpochBranchToNewspaperBases < ActiveRecord::Migration
  def change
    add_reference :newspaper_bases, :epoch_branch, index: true
  end
end
