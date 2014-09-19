class NewspaperBase < ActiveRecord::Base
  include Geokit::Geocoders  
  before_save do
    geo  = MultiGeocoder.geocode(display_address)
    self.latitude = geo.lat
    self.longitude = geo.lng
  end
  
  def update_lat_lng
    #FIXME add google api key will work, otherwise will be limitation of query
    #geo = Geokit::Geocoders::GoogleGeocoder.geocode(display_address)
    geo  = MultiGeocoder.geocode(display_address)
    update_attributes(latitude: geo.lat, longitude: geo.lng)
  end
        
  def display_address
    "#{address}, #{city}, #{state}, #{zip}"
  end
end
