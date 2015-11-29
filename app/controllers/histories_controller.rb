class HistoriesController < ApplicationController
  before_action :authenticate_user!
  def index
  end

  def trend
    histories = History.where(box_type: 'NewspaperBox').map do |h|
      [
        h.created_at.strftime('%Y%m%d').to_i,
        h.newspaper
      ]
    end
    render json: histories
  end
end
