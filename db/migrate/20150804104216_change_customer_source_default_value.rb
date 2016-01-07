class ChangeCustomerSourceDefaultValue < ActiveRecord::Migration
  def change
    change_column :users, :source, :string, default: ''
  end
end
