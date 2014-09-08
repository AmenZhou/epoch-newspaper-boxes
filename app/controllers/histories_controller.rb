class HistoriesController < ApplicationController
  before_action :authenticate_user!
  def index
    @histories = History.all
  end
end
