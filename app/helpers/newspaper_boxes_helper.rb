module NewspaperBoxesHelper
  def chart_deliver_percentage reports
    output = reports.map{|rs| [rs.group, rs.percentage]}
    output.unshift(['Delivery Type', 'Percentage'])
  end

  def chart_data reports
    output = reports.map{|rs| [rs.group, rs.sum]}
    output.unshift(['borough', 'amount'])
  end

  def chart_queens_data reports
    output = reports.map{|rs| [rs.group, rs.sum]}
    output.unshift(['Queens Areas', 'amount'])
  end

  def chart_weekday_average reports
    output = reports.map{|report| [report.group, report.average]}
    output.unshift(['Borough', 'WeekDay Average'])
  end

  def chart_weekend_average reports
    output = reports.map{|report| [report.group, report.average]}
    output.unshift(['Borough', 'Weekend Average'])
  end

  def chart_fri reports
    output = reports.map{|report| [report.group, report.fri]}
    output.unshift(['Borough', 'Fri'])
  end

  def chart_sat reports
    output = reports.map{|report| [report.group, report.sat]}
    output.unshift(['Borough', 'Sat'])
  end

  def zipcode_chart_data zipcode_report
    output = zipcode_report.drop(1).map{|rs| [rs.group.to_s, rs.mon, rs.tue, rs.wed, rs.thu, rs.fri, rs.sat]}
    output.unshift(['zipcode', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'])
  end

  def td_indentation(number=1)
    number.times.map{|i| "<td>"}.join(" ")
  end
  
  def newspaper_display_by_type
    controller.controller_name.gsub('_', ' ').titleize
  end

  def table_columns(newspaper_base)
    {
       delete: -> { link_to 'x', newspaper_base, method: :delete, data: { confirm: 'Are you sure?' }, remote: true },
       edit: -> { link_to 'Edit', edit_polymorphic_path(newspaper_base) },
       sort_num: -> {best_in_place newspaper_base, :sort_num, type: :input},
       address: -> {best_in_place newspaper_base, :address, type: :input},
       city: -> {best_in_place newspaper_base, :city, type: :input},
       state: -> { best_in_place newspaper_base, :state, type: :input },
       zip: -> { best_in_place newspaper_base, :zip, type: :input },
       borough_detail: -> { best_in_place newspaper_base, :borough_detail, type: :input },
       address_remark: -> { best_in_place newspaper_base, :address_remark, type: :input},
       created_at: -> { newspaper_base.created_at.strftime('%F') },
       deliver_type: -> { best_in_place newspaper_base, :deliver_type, type: :select, collection: newspaper_base.class.deliver_type },
       iron_box: -> { best_in_place newspaper_base, :iron_box, type: :input },
       plastic_box: -> { best_in_place newspaper_base, :plastic_box, type: :input },
       selling_box: -> { best_in_place newspaper_base, :selling_box, type: :input },
       paper_shelf: -> { best_in_place newspaper_base, :paper_shelf, type: :input },
       mon: -> { best_in_place newspaper_base, :mon, type: :input },
       tue: -> { best_in_place newspaper_base, :tue, type: :input },
       wed: -> { best_in_place newspaper_base, :wed, type: :input },
       thu: -> { best_in_place newspaper_base, :thu, type: :input },
       fri: -> { best_in_place newspaper_base, :fri, type: :input },
       sat: -> { best_in_place newspaper_base, :sat, type: :input },
       sun: -> { best_in_place newspaper_base, :sun, type: :input },
       date_t: -> { best_in_place newspaper_base, :date_t, type: :date },
       remark: -> { best_in_place newspaper_base, :remark, type: :textarea },
       building: -> { best_in_place newspaper_base, :building, type: :input },
       place_type: -> { best_in_place newspaper_base, :place_type, type: :input },
    }
  end

  def newspaper_form_items(f)
    {
      address: -> { f.text_field :address, class: 'form-control' },
      city: -> { f.text_field :city, class: 'form-control' },
      state: -> { f.text_field :state, class: 'form-control'  },
      zip: -> { f.number_field :zip, class: 'form-control'  },
      borough_detail: -> { f.text_field :borough_detail, class: 'form-control'  },
      address_remark: -> { f.text_area :address_remark, class: 'form-control'  },
      date_t: -> { f.datetime_select :date_t, class: 'form-control'  },
      deliver_type: -> { f.text_field :deliver_type, class: 'form-control'  },
      iron_box: -> { f.text_field :iron_box, class: 'form-control'  },
      plastic_box: -> { f.text_field :plastic_box, class: 'form-control'  },
      selling_box: -> { f.text_field :selling_box, class: 'form-control'  },
      paper_shelf: -> { f.text_field :paper_shelf, class: 'form-control'  },
      mon: -> { f.number_field :mon, class: 'form-control'  },
      tue: -> { f.number_field :tue, class: 'form-control'  },
      wed: -> { f.number_field :wed, class: 'form-control'  },
      thu: -> { f.number_field :thu, class: 'form-control'  },
      fri: -> { f.number_field :fri, class: 'form-control'  },
      sat: -> { f.number_field :sat, class: 'form-control'  },
      sun: -> { f.number_field :sun, class: 'form-control'  },
      remark: -> { f.text_area :remark, class: 'form-control'  },
      building: -> { f.text_field :building, class: 'form-control' },
      place_type: -> { f.text_field :place_type, class: 'form-control'  },
      sort_num: -> { f.number_field :sort_num, :step => 'any', class: 'form-control'  }
    }
  end

  def newspaper_new_path
    "#{controller.controller_name}/new"
  end

  def newspaper_index_path
    "#{controller.controller_name}"
  end

  def newspaper_export_path
    "#{controller.controller_name}/export_data"
  end

  def newspaper_recovery_path(newspaper_base)
    "#{controller.controller_name}/" + newspaper_base.id.to_s + "/recovery"
  end
end
