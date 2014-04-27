class AddIronBoxAndPlasticBoxAndSellingBoxAndPaperShelfToNewspaperBoxes < ActiveRecord::Migration
  def change
    add_column :newspaper_boxes, :iron_box, :integer
    add_column :newspaper_boxes, :plastic_box, :integer
    add_column :newspaper_boxes, :selling_box, :integer
    add_column :newspaper_boxes, :paper_shelf, :integer
  end
end
