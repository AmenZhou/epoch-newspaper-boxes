class RenameNoToBoxRecords < ActiveRecord::Migration
  def change
		rename_column :box_records, :no, :newspaper_boxes_id
  end
end
