json.array!(@addresses) do |address|
  json.extract! address, :id, :addressable_type, :country, :province, :city, :district, :details
  json.url address_url(address, format: :json)
end
