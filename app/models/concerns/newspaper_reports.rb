module NewspaperReports
  extend ActiveSupport::Concern

  module ClassMethods
    QueensArea = {"Queens West" => ["Woodside", "Elmhurst", "Rego Park", "Forest Hills"],
                  "Queens Middle" => ["Flushing"],
                  "Queens East" => ["Fresh Meadows", "Bayside", "Oakland Gardens", "Douglaston", "Little Neck"]}

    def deliver_type_percentage_by_borough borough
      newspapers = by_borough(borough)
      report_list = ReportList.new(newspapers: newspapers, group_name: 'deliver_type', days_range: :mon_2_sat)
      report_list.reports.sort_by(&:percentage).reverse.first(10)
    end

    def deliver_type_percentage
      report_list = ReportList.new(klass: self, group_name: 'deliver_type', days_range: :mon_2_sat)
      report_list.reports.sort_by(&:percentage).reverse.first(10)
    end

    #REPORT GENERATE RELATED METHODS
    def weekday_average_report
      report_list = ReportList.new(klass: self, group_name: 'borough_detail', days_range: :mon_2_thu)
      report_list.reports
    end

    def weekend_average_report
      report_list = ReportList.new({klass: self, group_name: 'borough_detail', days_range: :fri_2_sat})
      report_list.reports
    end

    def report
      report_list = ReportList.new({klass: self, group_name: 'borough_detail', days_range: :mon_2_sat})
      report_list.reports
    end

    def report_queens
      report_list = ReportList.new
      QueensArea.each do |key, value|
        newspaper = by_borough('Queens').by_city(value).sum_of_day.first
        report = Report.new(newspaper: newspaper, group_name: 'Queens Area', group: key + ' - ' + value.join(', '), days_range: :mon_2_sat)
        report.set_attributes
        report_list.add_to_list(report)
      end
      report_list.reports
    end

    def zipcode_report
      report_list = ReportList.new({klass: self, group_name: 'zip', days_range: :mon_2_sat})
      ###Add last row as a sum
      report_list.generate_weekday_columns_sum
      report_list.reports
    end

    def single_day_borough_report day = :fri
      report_list = ReportList.new({klass: self, group_name: 'borough_detail', days_range: day})
      report_list.reports
    end
  end
end
