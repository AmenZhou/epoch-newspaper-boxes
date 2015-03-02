class ReportsController < ApplicationController
  before_action :set_klass

  def report
    @report = @klass.report
    @report_queens = @klass.report_queens
    @weekday_average = @klass.weekday_average_report
    @weekend_average = @klass.weekend_average_report
    @fri = @klass.single_day_borough_report(:fri)
    @sat = @klass.single_day_borough_report(:sat)
    @all_deliver_type_percentage = @klass.deliver_type_percentage
    @queens_deliver_type_percentage = @klass.deliver_type_percentage_by_borough('Queens')
    @manhattan_deliver_type_percentage = @klass.deliver_type_percentage_by_borough('Manhattan')
    @brooklyn_deliver_type_percentage = @klass.deliver_type_percentage_by_borough('Brooklyn')
    @newjersey_deliver_type_percentage = @klass.deliver_type_percentage_by_borough('New Jersey')
  end

  def zipcode_report
    @zipcode_report = NewspaperBox.zipcode_report
  end

  private

  def set_klass
    @klass = (params[:table_type] || 'NewspaperBox').constantize
  end
end