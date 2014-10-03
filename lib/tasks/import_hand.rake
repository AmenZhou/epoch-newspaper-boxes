desc "import csv file"
task import_hand_csv: :environment do
  start_time = Time.now
  puts 'backup data before delete ...'
  NewspaperHand.export_data
  puts 'deleting data'
  NewspaperHand.where(type: 'NewspaperHand').destroy_all
  lines = File.readlines("lib/newspaper_hands_export.csv")
  titles = lines.first.downcase.split("|")
  titles.pop
  lines.drop(1).each do |row|
    data = row.gsub("\n", "").split("|")
    newspaper_box = NewspaperHand.new
    %w(longitude langtitude created_at).each do |title|
      titles.delete_if{|t| t == title}
    end
    titles.each_with_index do |col_name, index|
      next if col_name == 'address' and (data[index].blank? or data[index].nil?)
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
