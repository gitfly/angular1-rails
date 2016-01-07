class AddZipCodeToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :zip_code, :integer, default: 0
  end
end
