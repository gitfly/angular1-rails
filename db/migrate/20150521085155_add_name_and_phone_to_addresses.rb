class AddNameAndPhoneToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :name, :string
    add_column :addresses, :phone, :string
    Address.find_in_batches do |addresses|
      addresses.each do |address|
        if address.addressable_type == 'User'
          user = address.addressable
          address.update_attributes!(name: user.name, phone: user.phone)
        end
      end
    end
  end
end
