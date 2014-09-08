class AddColumnsToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :city_sum, :integer
    add_column :histories, :borough_sum, :integer
    add_column :histories, :zip_sum, :integer
  end
end
