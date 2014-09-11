desc "import csv file"
task import_csv2: :environment do
  start_time = Time.now
  NewspaperBox.destroy_all
  lines = File.readlines("lib/newspaper_export.csv")
  titles = lines.first.split("|")
  titles.pop
  lines.drop(1).each do |row|
    data = row.gsub("\n", "").split("|")
    newspaper_box = NewspaperBox.new
    %w(longitude langtitude create_at).each do |title|
      titles.delete_if{|t| t == title}
    end
    titles.each_with_index do |col_name, index|
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
