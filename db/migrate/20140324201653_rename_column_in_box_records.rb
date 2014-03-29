class RenameColumnInBoxRecords < ActiveRecord::Migration
  def change
		rename_column :box_records, :newspaper_boxes_id, :newspaper_box_id
  end
end
