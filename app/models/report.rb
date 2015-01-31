class Report
  attr_accessor :area, :zip, :borough_detail, :city, :mon, :tue, :wed, :thu, :fri, :sat, :sun, :sum, :average, :percentage, :group_name, :group
  cattr_accessor :reports
  
  Weekday2NewspaperBox = [:mon, :tue, :wed, :thu, :fri, :sat, :sun]
  CalcType = [:amount, :weekday_average, :weekend_average]
  
  def initialize(group=nil, group_value=0)
    if group
      self.send("#{group}=", group_value)
    end
    self.sum = 0
  end
  
  def set_weekday(weekday, newspaper_count)
    self.send("#{weekday}=", newspaper_count || 0)
  end
  
  def set_report(newspaper_box, days)
    days.each do |weekday|
      self.set_weekday(weekday, newspaper_box.send(weekday))
      self.sum += self.send(weekday) unless self.send(weekday).nil?
    end
  end

  def set_seven_weekday_and_sum(newspaper_box, calc_type=:amount)
    if calc_type == :amount
      self.set_report(newspaper_box, Weekday2NewspaperBox)
    elsif calc_type == :weekday_average
      self.set_report(newspaper_box, Weekday2NewspaperBox[0..3])
      self.average = self.sum / 4
    elsif calc_type == :weekend_average
      self.set_report(newspaper_box, Weekday2NewspaperBox[4..5])
      self.average = self.sum / 2
    end
  end

  def row_percentage newspaper_total_amount
    self.percentage = (sum.to_f / newspaper_total_amount * 100).round(3)
  end

  def self.generate_weekday_columns_sum
    report = Report.new()
    (Weekday2NewspaperBox + [:sum]).each do |weekday|
      report.send("#{weekday}=", self.reports.inject(0){|sum, report| sum += report.try(:send, weekday) || 0})
    end
    report
  end

  def self.add_to_list report
    self.reports << report
  end

  def self.initialize_list newspapers, group_name, amount_for_percentage
    self.reports = []
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
