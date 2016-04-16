class AddNewBoxFlgToNespaperBoxes < ActiveRecord::Migration
  def up
    add_column :newspaper_bases, :new_box_flg, :boolean, default: false
  end
end
