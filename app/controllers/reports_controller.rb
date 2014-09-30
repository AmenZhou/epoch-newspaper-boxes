class ReportsController < ApplicationController
  def report
    model = params[:table_type] || 'NewspaperBox'
    @report = model.constantize.report
    @report_queens = model.constantize.report_queens
  end
  
  def zipcode_report
    @zipcode_report = NewspaperBox.zipcode_report
  end
end