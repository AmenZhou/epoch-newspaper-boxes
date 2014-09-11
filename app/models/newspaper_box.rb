class NewspaperBox < ActiveRecord::Base
  include Geokit::Geocoders
  has_many :box_records
  # attr_accessible :address, :city, :state
  scope :by_city, -> (city) { where(city: city) }
  scope :by_borough, -> (borough) {where(borough_detail: borough)}
  default_scope -> {where(trash: false)}
  
  before_save do
    geo  = MultiGeocoder.geocode(display_address)
    self.latitude = geo.lat
    self.longitude = geo.lng
  end
  
  after_save :process_history

  QueensArea = {"Queens1" => ["Woodside", "Elmhurst", "Rego Park", "Forest Hills"],
                "Queens2" => ["Flushing"],
                "Queens3" => ["Fresh Meadows", "Bayside", "Oakland Gardens", "Douglaston", "Little Neck"]}


  ExportFilePath = "db/newspaper_export.csv"
    
  class << self
    def zipcode_list
      @zipcode_list ||= self.pluck(:zip).uniq.compact.sort
    end

    def city_list
      @city_list ||= self.pluck(:city).uniq.compact.sort
    end

    def borough_list
      @borough_list ||= self.pluck(:borough_detail).uniq.compact.sort
    end
  end

  def self.avg_week_count
    total = NewspaperBox.all.inject(0){|sum, np| sum += np.week_count}
    (total.to_f / NewspaperBox.count).round(2)
  end

  def self.fix_nil
    %w(mon tue wed thu fri sat sun).each do |day|
      NewspaperBox.where("#{day} is null").update_all("#{day}= 0")
    end
  end
 
      def weekday_changed?
        %w(mon tue wed thu fri sat sun).each do |weekday|
          return true if self.send("#{weekday}_changed?")
        end
        false
      end

      def process_history
        if new_record? or weekday_changed?
          History.generate_a_record(self)
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

  def week_count
    mon + tue + wed + thu + fri + sat + sun rescue 0
  end
  #REPORT GENERATE RELATED METHODS
  def self.report
    calc_paper_amount(:borough_detail)
  end

  def self.report_queens
    newspaper_boxes = NewspaperBox.where(borough_detail: 'Queens')
    reports = []
    NewspaperBox::QueensArea.each do |k, v|
      rs = newspaper_boxes.where(city: v).select("sum(mon) as mon, sum(tue) as tue,  sum(wed) as wed, sum(thu) as thu,  sum(fri) as fri,  sum(sat) as sat, sum(sun) as sun")
      report = Report.new(:area,  k + " (" + v.join(" ") + ")")
      report.set_seven_weekday_and_sum(rs.first)
      reports << report
    end
    reports
  end

  def self.zipcode_report
    reports = calc_paper_amount(:zip)
    ###Add last row as a sum
    reports << Report.generate_weekday_columns_sum(reports)
    reports
  end
      
      def self.calc_paper_amount_by_newspaper_boxes(newspaper_boxes, group)
        reports = []
        newspaper_boxes.each do |row|
          report = Report.new(group, row.send(group))
          report.set_seven_weekday_and_sum(row)
          reports << report
        end
        reports
      end

      def self.calc_paper_amount(group=nil)
        if group.nil?
          rs = NewspaperBox.select("sum(mon) as mon, sum(tue) as tue,  sum(wed) as wed, sum(thu) as thu,  sum(fri) as fri,  sum(sat) as sat, sum(sun) as sun")
        else
          rs = NewspaperBox.group(group).select("#{group}, sum(mon) as mon, sum(tue) as tue,  sum(wed) as wed, sum(thu) as thu,  sum(fri) as fri,  sum(sat) as sat, sum(sun) as sun")
        end
        calc_paper_amount_by_newspaper_boxes(rs, group)
      end
      
  def self.get_amount_by(group, condition)
    reports = calc_paper_amount(group)
    reports.select! { |r| r.send(group) == condition}
  end
  
  
  def is_newspaper_box?
    true if self.deliver_type == 'Newspaper box'
  end

  def self.generate_a_line(type="title", newspaper_box=nil)
    line = ""
    %w(sort_num address city state zip borough_detail address_remark date_t deliver_type remark iron_box plastic_box selling_box paper_shelf mon tue wed thu fri sat sun latitude longitude created_at).each do |attr|
      if type == "title"
        line += attr + '|'
      else
        line += newspaper_box.send(attr).to_s + '|'
      end
    end
    line.gsub("\n", "")
  end

  def self.export_data
    #DateTime.now.strftime('%D')
    file = File.new(NewspaperBox::ExportFilePath, 'w')
    
    file.puts(generate_a_line("title") + "\n")
    
    NewspaperBox.all.each do |nb|
      file.puts(generate_a_line("data", nb) + "\n")
    end
    file.close()
  end
end
