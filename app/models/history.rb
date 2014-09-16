class History < ActiveRecord::Base
  def self.generate_a_record(newspaper_box=nil)
    attr = {}
    attr[:newspaper] = NewspaperBox.all.inject(0){|sum, np| sum += np.week_count}
    attr[:box] = NewspaperBox.count
    attr[:borough] = newspaper_box.borough_detail
    sum_hash = NewspaperBox.get_amount_by(:borough_detail, newspaper_box.borough_detail)
    attr[:borough_sum] = sum_hash.try("first").try(:sum)
    attr[:zipcode] = newspaper_box.zip
    sum_hash = NewspaperBox.get_amount_by(:zip, newspaper_box.zip)
    attr[:zip_sum] = sum_hash.try("first").try(:sum)
    attr[:city] = newspaper_box.city
    sum_hash = NewspaperBox.get_amount_by(:city, newspaper_box.city)
    attr[:city_sum] = sum_hash.try("first").try(:sum)
    
    history = History.new(attr)
    unless history.save
      p "History Save error" + history.errors
    end
  end
end
