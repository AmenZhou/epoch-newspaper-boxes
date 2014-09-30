class NewspaperHand < NewspaperBase
  ColumnName = [:delete, :sort_num, :address, :city, :state, :zip, :borough_detail, :address_remark, :created_at, :deliver_type, :mon, :tue, :wed, :thu, :fri, :sat, :sun, :date_t, :remark, :building, :place_type]
  SumArray = [:mon, :tue, :wed, :thu, :fri, :sat, :sun]
end