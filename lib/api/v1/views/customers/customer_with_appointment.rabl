object @customer

attributes :id, :phone, :name, :weixin
  
node(:appointment_id) do
  @appointment.id
end