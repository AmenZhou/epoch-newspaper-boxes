class RemoveColumnNoInNewspaperBoxes < ActiveRecord::Migration
  def change
		remove_column :newspaper_boxes, :no
  end
end
