class ReportsController < ApplicationController
  def report
    @report = NewspaperBox.report
    @report_queens = NewspaperBox.report_queens
  end
  
  def zipcode_report
    @zipcode_report = NewspaperBox.zipcode_report
  end
end