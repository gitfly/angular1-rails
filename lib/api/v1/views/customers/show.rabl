object @customer

attributes :id, :email, :phone, :avatar_url, :name, :weixin, :is_member, 
  :balance, :discount, :show_discount, :birthday, :weixin_nickname, :show_gender, 
  :gender, :job, :source, :customer_type, :recharge_total, :sensitivity, 
  :tags, :service_number, :show_sensitivity, :show_source, :type

@customer ||= locals[:object]

if @customer.referrer
  node (:referrer) do 
  	{
  		name: @customer.referrer.name,
  	  weixin: @customer.referrer.weixin,
  	  phone: @customer.referrer.phone,
  	  weixin_nickname: @customer.referrer.weixin_nickname
  	}
  end
end

if @with_address
  node(:addresses) do |m|
    @customer.addresses.useful.map do |address|
      partial("addresses/address", object: address)
    end
  end
end
