class ReportList
  attr_accessor :reports, :group_name, :days_range, :newspaper_total_amount
  DaysRange = [:mon_2_thu, :fri_2_sat, :fri, :sat, :mon_2_sat]

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

  def initialize newspapers, group_name, days_range, newspaper_total_amount = nil
    self.reports = []
    self.group_name = group_name
    self.days_range = days_range
    self.newspaper_total_amount = newspaper_total_amount
    newspapers.each do |row|
      report = Report.new
      report.group_name = group_name
      report.group = row.send(group_name)
      report.set_attributes(row, days_range)
      next if report.sum == 0
      report.row_percentage(newspaper_total_amount) if newspaper_total_amount
      self.reports << report
    end
  end
end
