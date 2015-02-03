class Report
  attr_accessor :mon, :tue, :wed, :thu, :fri, :sat, :sun, :sum, :average, :percentage, :group_name, :group, :days_range, :newspaper, :newspaper_total_amount

  Weekday2NewspaperBox = [:mon, :tue, :wed, :thu, :fri, :sat, :sun]
  CalcType = [:amount, :weekday_average, :weekend_average]

  def initialize params = {}
    self.group_name = params[:group_name]
    self.days_range = params[:days_range] || :mon_2_sat
    self.newspaper = params[:newspaper]
    self.group = params[:group] || newspaper.send(group_name) if newspaper
    self.sum = 0
  end

  def set_weekday(weekday, newspaper_count)
    self.send("#{weekday}=", newspaper_count || 0)
  end

  def set_report(days)
    days.each do |weekday|
      self.set_weekday(weekday, newspaper.send(weekday))
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

  def set_attributes
    if days_range == :mon_2_sat
      self.set_report(Weekday2NewspaperBox[0..5])
      self.average = sum / 6
    elsif days_range == :mon_2_thu
      self.set_report(Weekday2NewspaperBox[0..3])
      self.average = sum / 4
    elsif days_range == :fri_2_sat
      self.set_report(Weekday2NewspaperBox[4..5])
      self.average = sum / 2
    elsif days_range == :fri
      self.set_report(:fri)
    elsif days_range == :sat
      self.set_report(:sat)
    end
  end

  def row_percentage
    self.percentage = (sum.to_f / newspaper_total_amount * 100).round(3)
  end
end
