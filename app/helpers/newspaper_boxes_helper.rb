module NewspaperBoxesHelper
  def chart_data report
    output = report.drop(1).map{|rs| [rs[:city], rs[:amount]]}
    output.unshift(['city', 'amount'])
  end

  def zipcode_chart_data zipcode_report
    output = zipcode_report.drop(1).map{|rs| [rs[:zipcode].to_s, rs[:mon], rs[:tue], rs[:wed], rs[:thu], rs[:fri], rs[:sat], rs[:sun]]}
    output.unshift(['zipcode', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'])
  end
end
