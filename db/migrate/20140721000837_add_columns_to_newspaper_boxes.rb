class AddColumnsToNewspaperBoxes < ActiveRecord::Migration
  def change
    add_column :newspaper_boxes, :mon, :integer
    add_column :newspaper_boxes, :tue, :integer
    add_column :newspaper_boxes, :wed, :integer
    add_column :newspaper_boxes, :thu, :integer
    add_column :newspaper_boxes, :fri, :integer
    add_column :newspaper_boxes, :sat, :integer
    add_column :newspaper_boxes, :sun, :integer
  end
end
