module NewspaperBoxesHelper
  def chart_data report
    output = report.drop(1).map{|rs| [rs[:borough], rs[:amount]]}
    output.unshift(['borough', 'amount'])
  end

  def chart_queens_data report
    output = report.map{|rs| [rs[:area], rs[:amount]]}
    output.unshift(['Queens Areas', 'amount'])
  end

  def zipcode_chart_data zipcode_report
    output = zipcode_report.drop(1).map{|rs| [rs[:zipcode].to_s, rs[:mon], rs[:tue], rs[:wed], rs[:thu], rs[:fri], rs[:sat], rs[:sun]]}
    output.unshift(['zipcode', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'])
  end

  def deliver_type newspaper_boxes
    #[[1, "Spain"], [2, "Italy"], [3, "Germany"], [4, "France"]]
    #NewspaperBoxes.pluck(:deliver_type)
    @delivery_types ||= newspaper_boxes.pluck(:deliver_type).compact.uniq.map{|np| [np, np]}
  end
 
end
