class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer :newspaper
      t.integer :box
      t.string :borough
      t.integer :zipcode
      t.string :city

      t.timestamps
    end
  end
end
