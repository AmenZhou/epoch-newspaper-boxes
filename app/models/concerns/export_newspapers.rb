module ExportNewspapers
  extend ActiveSupport::Concern

  module ClassMethods
    def generate_a_line(type="title", newspaper_box=nil)
      line = ""
      self::ColumnName.each do |attr|
        next if [:delete, :edit].include?(attr)
        if type == "title"
          line += attr.to_s + '|'
        else
          line += newspaper_box.send(attr).to_s + '|'
        end
      end
      line.gsub("\n", "").encode("UTF-8")
    end

    def export_data(epoch_branch_id)
      file_path = ""
      unless File.directory?('lib/export')
        Dir.mkdir 'lib/export'
      end
      File.open('lib/export/' + self.to_s.downcase + '_export_'+ Time.now.strftime("%d%m%Y-%H:%M") + '.csv', 'w') do |file|
        file.puts(generate_a_line("title") + "\n")

        self.where(epoch_branch_id: epoch_branch_id).each do |nb|
          file.puts(generate_a_line("data", nb) + "\n")
        end
        file_path = file.path
      end
      file_path
    end
  end
end
