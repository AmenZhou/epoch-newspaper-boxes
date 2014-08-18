class NewspaperBox < ActiveRecord::Base
  include Geokit::Geocoders
  has_many :box_records
  # attr_accessible :address, :city, :state
  scope :by_city, -> (city) { where(city: city) }

  before_save do
    geo  = MultiGeocoder.geocode(display_address)
    self.latitude = geo.lat
    self.longitude = geo.lng
  end


  class << self
    def zipcode_list
      @zipcode_list ||= self.pluck(:zip).uniq.compact.sort
    end
    
    def city_list
      @city_list ||= self.pluck(:city).uniq.compact.sort
    end
  end

  def self.upload(file) 
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      newspaper_box = find_by_id(row["id"]) || new
      newspaper_box.attributes = row.to_hash
      newspaper_box.save!
    end
  end

  def self.avg_week_count
    total = NewspaperBox.all.inject(0){|sum, np| sum += np.week_count}
    (total.to_f / NewspaperBox.count).round(2)
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.fix_nil
    %w(mon tue wed thu fri sat sun).each do |day|
      NewspaperBox.where("#{day} is null").update_all("#{day}= 0")
    end
  end
 
  def display_address
    "#{address}, #{city}, #{state}, #{zip}"
  end

  def update_lat_lng
    #FIXME add google api key will work, otherwise will be limitation of query
    #geo = Geokit::Geocoders::GoogleGeocoder.geocode(display_address)
    geo  = MultiGeocoder.geocode(display_address)
    update_attributes(latitude: geo.lat, longitude: geo.lng)
  end

  def self.report
    #will return [{city:, amount: ,}, 
    #{}]
    rs = NewspaperBox.group(:city).select("city, sum(mon) as mon, sum(tue) as tue,  sum(wed) as wed, sum(thu) as thu,  sum(fri) as fri,  sum(sat) as sat, sum(sun) as sun")
    report = []
    rs.each do |row|
      hash = {}
      hash[:city] = row.city
      hash[:amount] = row.week_count
      report << hash
    end
    report
  end

  def week_count
    mon + tue + wed + thu + fri + sat + sun rescue 0
  end

  def self.zipcode_report
    rs = NewspaperBox.group(:zip).select("zip, sum(mon) as mon, sum(tue) as tue,  sum(wed) as wed, sum(thu) as thu,  sum(fri) as fri,  sum(sat) as sat, sum(sun) as sun")
    report = []
    rs.each do |row|
      hash = {}
      hash[:zipcode] = row.zip
      %w(mon tue wed thu fri sat sun).each do |week_day|
        #eval("hash[:#{week_day}] = row.#{week_day}")
        hash.send(:[]=, week_day.to_sym, row.send(week_day))
      end
      report << hash
    end
    report
  end

  def is_newspaper_box?
    true if self.deliver_type == 'Newspaper box'
  end
end
