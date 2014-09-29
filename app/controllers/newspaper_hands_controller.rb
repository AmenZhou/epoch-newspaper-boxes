class NewspaperHandsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_newspaper_hand, only: [:update, :destroy]

  def create
    @newspaper_hand = NewspaperHand.new(newspaper_hand_params)
    respond_to do |format|
      if @newspaper_hand.save
        format.html { redirect_to newspaper_bases_path(table_type: 'hands'), notice: 'Newspaper hand was successfully created.' }
      else
        format.html { render 'newspaper_bases/new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @newspaper_hand.update(newspaper_hand_params)
        format.json { head :no_content }
      else
        format.json { render json: @newspaper_hand.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @newspaper_hand = NewspaperHand.find(params[:id])
    @nb_id = @newspaper_hand.id
    if @newspaper_hand.trash
      @newspaper_hand.destroy
      get_newspaper_bases_n_sum(true)
    else
      @newspaper_hand.update(trash: true)
      get_newspaper_bases_n_sum(false)
    end
    @newspaper_hands = NewspaperHand.all
    respond_to do |format|
      format.js
      format.json { head :no_content }
    end
  end

  private

  def set_newspaper_hand
    @newspaper_hand = NewspaperHand.find(params[:id])
  end

  def newspaper_hand_params
    params.require(:newspaper_hand).permit(:address, :city, :state, :zip, :borough_detail, :address_remark, :date_t, :deliver_type, :remark, :mon, :tue, :wed, :thu, :fri, :sat, :sun, :sort_num, :building, :place_type)
  end
end
