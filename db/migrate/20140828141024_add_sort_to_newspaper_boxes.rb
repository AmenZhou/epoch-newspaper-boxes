class AddSortToNewspaperBoxes < ActiveRecord::Migration
  def change
    add_column :newspaper_boxes, :sort, :float
  end
end
