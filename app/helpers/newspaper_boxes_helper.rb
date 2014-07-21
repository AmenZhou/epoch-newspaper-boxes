module NewspaperBoxesHelper
  def chart_data report
    output = report.drop(1).map{|rs| [rs[:city], rs[:amount]]}
    output.unshift(['city', 'amount'])
  end
end
