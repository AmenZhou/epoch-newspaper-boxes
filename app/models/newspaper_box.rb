class NewspaperBox < ActiveRecord::Base
  has_many :box_records
  # attr_accessible :address, :city, :state
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


  def self.report
    #will return [{city:, amount: ,}, 
    #{}]
    rs = NewspaperBox.group(:city).select("city, sum(mon) as mon, sum(tue) as tue,  sum(wed) as wed, sum(thu) as thu,  sum(fri) as fri,  sum(sat) as sat, sum(sun) as sun")
    report = []
    rs.each do |row|
      hash = {}
      hash[:city] = row.city
      hash[:amount] = row.mon + row.tue + row.wed + row.thu + row.fri + row.sat + row.sun
      report << hash
    end
    report
  end
end
