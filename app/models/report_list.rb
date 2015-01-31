class ReportList
  attr_accessor :reports, :group_name

  def generate_weekday_columns_sum
    report = Report.new()
    (Report::Weekday2NewspaperBox + [:sum]).each do |weekday|
      report.send("#{weekday}=", self.reports.inject(0){|sum, report| sum += report.try(:send, weekday) || 0})
    end
    self.reports << report
  end

  def add_to_list report
    self.reports << report
  end

  def initialize newspapers, group_name, amount_for_percentage
    self.reports = []
    self.group_name = group_name
    newspapers.each do |row|
      report = Report.new
      report.group_name = group_name
      report.group = row.send(group_name)
      report.set_seven_weekday_and_sum(row, :amount)
      report.row_percentage(amount_for_percentage)
      self.reports << report
    end
  end
end
