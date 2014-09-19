class CreateNewspaperBases < ActiveRecord::Migration
  def change
    create_table :newspaper_bases do |t|
      t.string :address
      t.string :city
      t.string :state
      t.integer :zip
      t.string :borough_detail
      t.string :address_remark
      t.datetime :date_t
      t.string :deliver_type
      t.text :remark
      t.integer :iron_box
      t.integer :plastic_box
      t.integer :selling_box
      t.integer :paper_shelf
      t.integer :mon, default: 0
      t.integer :tue, default: 0
      t.integer :wed, default: 0
      t.integer :thu, default: 0
      t.integer :fri, default: 0
      t.integer :sat, default: 0
      t.integer :sun, default: 0
      t.float :latitude
      t.float :longitude
      t.float :sort_num
      t.boolean :trash, default: false
      t.string :building
      t.string :type
      t.string :place_type

      t.timestamps
    end
  end
end
