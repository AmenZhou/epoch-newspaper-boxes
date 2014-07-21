class AddColumnsToNewspaperBoxes < ActiveRecord::Migration
  def change
    add_column :newspaper_boxes, :mon, :integer, default: 0
    add_column :newspaper_boxes, :tue, :integer, default: 0
    add_column :newspaper_boxes, :wed, :integer, default: 0
    add_column :newspaper_boxes, :thu, :integer, default: 0
    add_column :newspaper_boxes, :fri, :integer, default: 0
    add_column :newspaper_boxes, :sat, :integer, default: 0
    add_column :newspaper_boxes, :sun, :integer, default: 0
  end
end
