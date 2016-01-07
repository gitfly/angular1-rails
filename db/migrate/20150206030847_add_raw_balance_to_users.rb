class AddRawBalanceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :raw_balance, :integer, default: 0
  end
end
