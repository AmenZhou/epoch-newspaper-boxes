class NewspaperBase < ActiveRecord::Base
  include Geokit::Geocoders 
  include ExportNewspapers
  include NewspaperReports

  belongs_to :epoch_branch

  validates :type, presence: true
  scope :by_city, -> (city) { where(city: city) }
  scope :by_borough, -> (borough) {where(borough_detail: borough)}
  scope :by_epoch_branch_id, -> (branch_id) { where(epoch_branch_id: branch_id) }
  default_scope -> {where(trash: false)}

  before_save :update_lat_lng, except: [:destroy, :recovery]


  ColumnName = [:delete, :edit, :sort_num, :address, :city, :state, :zip, :borough_detail, :address_remark, :created_at, :deliver_type, :iron_box, :plastic_box, :selling_box, :paper_shelf, :mon, :tue, :wed, :thu, :fri, :sat, :sun, :date_t, :remark, :building, :place_type]
  SumArray = [:iron_box, :plastic_box, :selling_box, :paper_shelf, :mon, :tue, :wed, :thu, :fri, :sat, :sun]

  scope :by_address, -> (address) { where('address LIKE ?', "%#{address}%")}

  scope :by_group, ->(group) { group(group).select("#{group}, sum(mon) as mon, sum(tue) as tue,  sum(wed) as wed, sum(thu) as thu,  sum(fri) as fri,  sum(sat) as sat, sum(sun) as sun") }

  scope :sum_of_day, -> { select("sum(mon) as mon, sum(tue) as tue,  sum(wed) as wed, sum(thu) as thu,  sum(fri) as fri,  sum(sat) as sat, sum(sun) as sun") }

  class << self

    def weekly_total_amount
      select('sum(mon) + sum(tue) + sum(wed) + sum(thu) + sum(fri) + sum(sat) as mon').first.mon
    end

    def deliver_type
      #[[1, "Spain"], [2, "Italy"], [3, "Germany"], [4, "France"]]
      #NewspaperBoxes.pluck(:deliver_type)
      @delivery_types ||= self.pluck(:deliver_type).compact.reject(&:empty?).uniq.map{|np| [np, np]}
    end

    def zipcode_list
      @zipcode_list ||= self.pluck(:zip).uniq.compact.sort.delete_if(&:blank?)
    end

    def city_list
      @city_list ||= self.pluck(:city).uniq.compact.sort.delete_if(&:blank?)
    end

    def borough_list
      @borough_list ||= self.pluck(:borough_detail).uniq.compact.sort.delete_if(&:blank?)
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

  def week_count
    mon + tue + wed + thu + fri + sat + sun rescue 0
  end

  def is_newspaper_box?
    true if self.deliver_type == 'Newspaper box'
  end

  def generate_location_info
    location = {}
    location['latitude'] = latitude 
    location['longitude'] = longitude
    location['paper_count'] = instance_of?(NewspaperHand)? 0 : week_count
    location['address'] = display_address
    if type == 'NewspaperHand'
      location['icon'] = 'red'
    elsif deliver_type == 'Newspaper box'
      location['icon'] = 'green'
    else
      location['icon'] = 'blue'
    end
    location
  end
end
