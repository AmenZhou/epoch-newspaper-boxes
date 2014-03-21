json.array!(@newspaper_boxes) do |newspaper_box|
  json.extract! newspaper_box, :id, :no, :address, :city, :state, :zip, :borough_detail, :address_remark, :date_t, :deliver_type, :box_type, :remark
  json.url newspaper_box_url(newspaper_box, format: :json)
end
