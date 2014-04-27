class ImportController < ApplicationController
  def index
  end
  def upload_file
    NewspaperBox.upload(params[:file])
    redirect_to action: :index
  end
end
