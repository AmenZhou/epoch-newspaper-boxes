class AddNewBoxFlgToNespaperBoxes < ActiveRecord::Migration
  def up
    add_column :newspaper_bases, :new_box_flg, :boolean, default: false

    NewspaperBase.update_all(new_box_flg: false)
  end

  def down
    remove_column :newspaper_bases, :new_box_flg
  end
end
