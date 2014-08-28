class ChangeSortToSortNumAtNewspaperboxes < ActiveRecord::Migration
  def change
    rename_column :newspaper_boxes, :sort, :sort_num
  end
end
