class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_epoch_branch_id

  private

  def current_epoch_branch_id
    current_user.epoch_branch_id
  end

  def set_epoch_branch_id
    ReportList.epoch_branch_id = current_user.try(:epoch_branch_id) || EpochBranch.first.id
  end
end
