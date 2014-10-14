desc "Record history"
task daily_routine: :environment do
  %w(NewspaperBox NewspaperHand).each do |model_name|
    attr = {}
    attr[:newspaper] = model_name.constantize.all.inject(0){ |sum, np| sum += np.week_count }
    attr[:box] = model_name.constantize.count
    attr[:box_type] = model_name
    history = History.new(attr)
    if history.save
      File.open('log/history.log', 'w') do |f|
        f.write "Save a #{model_name} history record success"
      end
    else
      File.open('log/history.log', 'w') do |f|
        f.write "Error: Save a #{model_name} history record failed"
      end
    end
  end
end

desc "Backup Database"
task backup_database: :environment do
  system "mysqldump -u root -h localhost newspaper_box > /home/action/workspace/newspaper_db/mysql_dump_#{Time.now.strftime("%d%m%Y-%H:%M")}.sql"
end
