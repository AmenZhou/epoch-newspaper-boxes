class CreateBoxRecords < ActiveRecord::Migration
  def change
    create_table :box_records do |t|
      t.integer :no
      t.datetime :date_t
      t.integer :quantity
      t.text :remark

      t.timestamps
    end
  end
end
