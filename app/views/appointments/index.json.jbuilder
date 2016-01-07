json.array!(@appointments) do |appointment|
  json.extract! appointment, :id, :customer_id, :date
  json.url appointment_url(appointment, format: :json)
end
