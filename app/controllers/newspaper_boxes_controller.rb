class NewspaperBoxesController < NewspaperBasesController

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def newspaper_params
    params.require(:newspaper_box).permit(:new_box_flg, :address, :city, :state, :zip, :borough_detail, :address_remark, :date_t, :deliver_type, :iron_box, :plastic_box, :selling_box, :paper_shelf, :remark, :mon, :tue, :wed, :thu, :fri, :sat, :sun, :sort_num)
  end
end
