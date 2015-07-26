class CreateEpochBranches < ActiveRecord::Migration
  def change
    create_table :epoch_branches do |t|
      t.string :name

      t.timestamps
    end
  end
end
