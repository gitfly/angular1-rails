class AddMemberPhoneAndMemeberNameToConsumptionRecord < ActiveRecord::Migration
  def change
    add_column :consumption_records, :member_phone, :string
    add_column :consumption_records, :member_name, :string
  end
end
