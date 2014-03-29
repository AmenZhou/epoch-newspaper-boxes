json.array!(@box_records) do |box_record|
  json.extract! box_record, :id, :no, :date_t, :quantity, :remark
  json.url box_record_url(box_record, format: :json)
end
