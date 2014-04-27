class RemoveColumnBoxTypeToNewspaperBoxes < ActiveRecord::Migration
  def change
    remove_column :newspaper_boxes, :box_type
  end
end
