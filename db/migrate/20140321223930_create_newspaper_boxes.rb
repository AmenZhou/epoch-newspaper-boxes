class CreateNewspaperBoxes < ActiveRecord::Migration
  def change
    create_table :newspaper_boxes do |t|
      t.integer :no
      t.string :address
      t.string :city
      t.string :state
      t.integer :zip
      t.string :borough_detail
      t.text :address_remark
      t.datetime :date_t
      t.string :deliver_type
      t.string :box_type
      t.text :remark

      t.timestamps
    end
  end
end
