class HistoriesController < ApplicationController
  before_action :authenticate_user!
  def index
  end

  def trend
    #params[:filter] => weekly_delivery/box_amount
    box_type = params[:box_type] || 'NewspaperBox'
    histories = History.where(box_type: box_type,
                              epoch_branch_id: current_user.epoch_branch_id).order('created_at')
    if params[:filter] == 'weekly_delivery'
      data = histories.map do |h|
        [
          h.created_at.strftime('%Y-%m-%d'),
          h.newspaper
        ]
      end
    elsif params[:filter] == 'box_amount'
      data = histories.map do |h|
        [
          h.created_at.strftime('%Y-%m-%d'),
          h.box
        ]
      end
    end
    render json: data
  end
end
