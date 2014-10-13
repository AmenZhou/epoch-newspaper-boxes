desc "import csv file"
task import_csv2: :environment do
  start_time = Time.now
  puts 'backuping data...'
  NewspaperBox.export_data
  puts 'deleting data...'
  NewspaperBox.where(type: 'NewspaperBox').destroy_all
  lines = File.readlines("lib/newspaper_export.csv")
  titles = lines.first.split("|")
  titles.pop
  lines.drop(1).each do |row|
    data = row.gsub("\n", "").split("|")
    address_index = titles.index('address')
    next if data[address_index].blank? or data[address_index].nil?
    newspaper_box = NewspaperBox.new
    titles.each_with_index do |col_name, index|
      next if %w(longitude latitude created_at).include?(col_name)
      newspaper_box.send("#{col_name}=", data[index])
    end
    %w(mon tue wed thu fri sat sun).each do |weekday|
      newspaper_box.send("#{weekday}=", newspaper_box.send("#{weekday}").to_i)
    end
    newspaper_box.sort_num = newspaper_box.sort_num.to_f
    if newspaper_box.save
      print '.'
    else
      p  newspaper_box.errors
    end
  end
  puts "Total cost time: #{Time.now - start_time}"
end
