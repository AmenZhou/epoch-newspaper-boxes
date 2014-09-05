class AddTrashToNewspaperBoxes < ActiveRecord::Migration
  def change
    add_column :newspaper_boxes, :trash, :boolean, default: false
  end
end
