class HistoriesController < ApplicationController
  before_action :authenticate_user!
  def index
  end

  def trend
    histories = History.where(box_type: 'NewspaperBox').order('created_at').map do |h|
      [
        h.created_at.strftime('%Y-%m-%d'),
        h.newspaper
      ]
    end
    render json: histories
  end
end
