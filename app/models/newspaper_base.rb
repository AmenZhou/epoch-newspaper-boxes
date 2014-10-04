class NewspaperBase < ActiveRecord::Base
  include Geokit::Geocoders 
  validates :type, presence: true
  scope :by_city, -> (city) { where(city: city) }
  scope :by_borough, -> (borough) {where(borough_detail: borough)}
  default_scope -> {where(trash: false)}
  paginates_per 25

  after_save :process_history, unless: $rails_rake_task
  before_save :update_lat_lng, except: [:destroy, :recovery]

  QueensArea = {"Queens West" => ["Woodside", "Elmhurst", "Rego Park", "Forest Hills"],
                "Queens Middle" => ["Flushing"],
                "Queens East" => ["Fresh Meadows", "Bayside", "Oakland Gardens", "Douglaston", "Little Neck"]}

  ColumnName = [:delete, :sort_num, :address, :city, :state, :zip, :borough_detail, :address_remark, :created_at, :deliver_type, :iron_box, :plastic_box, :selling_box, :paper_shelf, :mon, :tue, :wed, :thu, :fri, :sat, :sun, :date_t, :remark, :building, :place_type]
  SumArray = [:iron_box, :plastic_box, :selling_box, :paper_shelf, :mon, :tue, :wed, :thu, :fri, :sat, :sun]

  class << self
    def zipcode_list
      self.pluck(:zip).uniq.compact.sort.delete_if(&:blank?)
    end

    def city_list
      self.pluck(:city).uniq.compact.sort.delete_if(&:blank?)
    end

    def borough_list
      self.pluck(:borough_detail).uniq.compact.sort.delete_if(&:blank?)
    end

    def get_newspaper_bases_n_sum(trash=false)
      @newspaper_bases = NewspaperBase.unscoped.where(trash: trash, type: @class_type)
      newspaper_sum
    end

    def newspaper_sum
      @newspaper_sum = {}
      model_name::SumArray.each do |week_day|
        @newspaper_sum.send( :[]=, week_day.to_sym, @newspaper_bases.sum(week_day.to_sym))
      end
    end

    def avg_week_count
      total = NewspaperBox.all.inject(0){|sum, np| sum += np.week_count}
      (total.to_f / NewspaperBox.count).round(2)
    end

    def fix_nil
      %w(mon tue wed thu fri sat sun).each do |day|
        NewspaperBox.where("#{day} is null").update_all("#{day}= 0")
      end
    end
    #REPORT GENERATE RELATED METHODS
    def report
      calc_paper_amount(:borough_detail)
    end

    def report_queens
      newspaper_boxes = self.where(borough_detail: 'Queens')
      reports = []
      NewspaperBox::QueensArea.each do |k, v|
        rs = newspaper_boxes.where(city: v).select("sum(mon) as mon, sum(tue) as tue,  sum(wed) as wed, sum(thu) as thu,  sum(fri) as fri,  sum(sat) as sat, sum(sun) as sun")
        report = Report.new(:area,  k + " (" + v.join(" ") + ")")
        report.set_seven_weekday_and_sum(rs.first)
        reports << report
      end
      reports
    end

    def zipcode_report
      reports = calc_paper_amount(:zip)
      ###Add last row as a sum
      reports << Report.generate_weekday_columns_sum(reports)
      reports
    end

    def calc_paper_amount_by_newspaper_boxes(newspaper_boxes, group)
      reports = []
      newspaper_boxes.each do |row|
        next if group && (row.send(group).nil? || row.send(group).blank?)
        if group
          report = Report.new(group, row.send(group))
        else
          report = Report.new
        end
        report.set_seven_weekday_and_sum(row)
        reports << report
      end
      reports
    end

    def calc_paper_amount(group=nil)
      if group.nil?
        rs = self.select("sum(mon) as mon, sum(tue) as tue,  sum(wed) as wed, sum(thu) as thu,  sum(fri) as fri,  sum(sat) as sat, sum(sun) as sun")
      else
        rs = self.group(group).select("#{group}, sum(mon) as mon, sum(tue) as tue,  sum(wed) as wed, sum(thu) as thu,  sum(fri) as fri,  sum(sat) as sat, sum(sun) as sun")
      end
      calc_paper_amount_by_newspaper_boxes(rs, group)
    end

    def get_amount_by(group, condition)
      reports = calc_paper_amount(group)
      reports.select! { |r| r.send(group) == condition}
    end

    def generate_a_line(type="title", newspaper_box=nil)
      line = ""
      self::ColumnName.each do |attr|
        next if [:delete].include?(attr)
        if type == "title"
          line += attr.to_s + '|'
        else
          line += newspaper_box.send(attr).to_s + '|'
        end
      end
      line.gsub("\n", "").encode("UTF-8")
    end

    def export_data
      file_path = ""
      unless File.directory?('lib/export')
        Dir.mkdir 'lib/export'
      end
      File.open('lib/export/' + self.to_s.downcase + '_export_'+ Time.now.strftime("%d%m%Y-%H:%M") + '.csv', 'w') do |file|
        file.puts(generate_a_line("title") + "\n")

        self.all.each do |nb|
          file.puts(generate_a_line("data", nb) + "\n")
        end
        file_path = file.path
      end
      file_path
    end
  end

  #instance method
  def update_lat_lng
    #FIXME add google api key will work, otherwise will be limitation of query
    geo  = MultiGeocoder.geocode(display_address)
    self.latitude = geo.lat
    self.longitude = geo.lng
  end

  def display_address
    "#{address}, #{city}, #{state}, #{zip}"
  end

  def weekday_changed?
    %w(mon tue wed thu fri sat sun).each do |weekday|
      return true if self.send("#{weekday}_changed?")
    end
    false
  end

  def process_history
    if (NewspaperBox.last.id == self.id) or weekday_changed?
      History.generate_a_record(self)
    end
  end

  def week_count
    mon + tue + wed + thu + fri + sat + sun rescue 0
  end

  def is_newspaper_box?
    true if self.deliver_type == 'Newspaper box'
  end
end
