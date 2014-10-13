class AddTypeToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :box_type, :string
  end
end
