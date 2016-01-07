object false

node(:addresses) do |m|
  @addresses.map do |address|
    partial("addresses/address", object: address)
  end
end

node(:customer) do |m|
  partial("customers/show", object: @customer)
end
