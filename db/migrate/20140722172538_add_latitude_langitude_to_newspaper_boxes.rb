class AddLatitudeLangitudeToNewspaperBoxes < ActiveRecord::Migration
  def change
    add_column :newspaper_boxes, :latitude, :float
    add_column :newspaper_boxes, :longitude, :float
  end
end
