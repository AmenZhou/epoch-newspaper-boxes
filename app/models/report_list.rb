class ReportList
  attr_accessor :reports, :group_name, :days_range, :newspaper_total_amount, :newspapers
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

  #params{group_name, days_range, newspapers, newspaper_total_amount, klass}
  def initialize params = {}
    self.reports = []
    if params.present?
      newspapers_t = params[:newspapers] || params[:klass]
      self.group_name = params[:group_name]
      self.days_range = params[:days_range] || :mon_2_sat
      self.newspaper_total_amount = newspapers_t.weekly_total_amount
      self.newspapers = newspapers_t.by_group(group_name)
      initialize_list
    end
  end

  def initialize_list
    return if newspapers.nil?
    newspapers.each do |row|
      report = Report.new(group_name: group_name, days_range: days_range, newspaper: row, newspaper_total_amount: newspaper_total_amount)
      report.set_attributes
      next if report.sum == 0
      report.row_percentage if newspaper_total_amount
      self.reports << report
    end
  end
end
