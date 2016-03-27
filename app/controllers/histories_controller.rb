class HistoriesController < ApplicationController
  before_action :authenticate_user!
  def index
  end

  def trend
    box_type = params[:box_type] || 'NewspaperBox'
    histories = History.where(box_type: box_type,
                              epoch_branch_id: current_user.epoch_branch_id).order('created_at').map do |h|
      [
        h.created_at.strftime('%Y-%m-%d'),
        h.newspaper
      ]
    end
    render json: histories
  end
end
