class Report
  attr_accessor :zip, :borough_detail, :city, :mon, :tue, :wed, :thu, :fri, :sat, :sun, :sum
  
  Weekday2NewspaperBox = [:mon, :tue, :wed, :thu, :fri, :sat, :sun]
  
  def initialize(group=nil, group_value=0)
    if group
      self.send("#{group}=", group_value)
    end
    self.sum = 0
  end
  
  def set_weekday(weekday, newspaper_count)
    self.send("#{weekday}=", newspaper_count)
  end
  
  def set_seven_weekday_and_sum(newspaper_box)
    Report::Weekday2NewspaperBox.each do |weekday|
      set_weekday(weekday, newspaper_box.send(weekday))
      self.sum += self.send(weekday)
    end
  end
  
  def self.generate_weekday_columns_sum(reports)
    report = Report.new()
    arr = Report::Weekday2NewspaperBox << :sum
    arr.each do |weekday|
      report.send("#{weekday}=", reports.inject(0){|sum, report| sum += report.send(weekday)})
    end
    report
  end
end