class NewspaperHandsController < NewspaperBasesController

  private

  def newspaper_params
    params.require(:newspaper_hand).permit(:address, :city, :state, :zip, :borough_detail, :address_remark, :date_t, :deliver_type, :remark, :mon, :tue, :wed, :thu, :fri, :sat, :sun, :sort_num, :building, :place_type)
  end
end
