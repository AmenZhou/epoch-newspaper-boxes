desc "import csv file"
task import_csv: :environment do
  start_time = Time.now
  NewspaperBox.destroy_all
  lines = File.readlines("public/import.csv")
  lines.drop(1).each do |row|
    data = row.gsub("\n", "").split("\;")
    next if data[2].blank? or data[3].blank?
    NewspaperBox.create(
      address: data[0].gsub('-', ''),
      city: data[1],
      state: data[2],
      zip: data[3],
      borough_detail: data[4],
      address_remark: data[5],
      mon: data[6].to_i,
      tue: data[7].to_i,
      wed: data[8].to_i,
      thu: data[9].to_i,
      fri: data[10].to_i,
      sat: data[11].to_i,
      sun: data[12].to_i,
      deliver_type: data[13],
      iron_box: data[14],
      plastic_box: data[15],
      selling_box: data[16],
      paper_shelf: data[17],
      date_t: data[18],
      remark: data[19]
    )
    print '.'
  end
  puts "Total cost time: #{Time.now - start_time}"
end
