class ReportsController < ApplicationController
  def report
    model = params[:table_type] || 'NewspaperBox'
    @report = model.constantize.report
    @report_queens = model.constantize.report_queens
    @weekday_average = model.constantize.weekday_average_report
    @weekend_average = model.constantize.weekend_average_report
    @fri = model.constantize.single_day_borough_report(:fri)
  end

  def zipcode_report
    @zipcode_report = NewspaperBox.zipcode_report
  end
end