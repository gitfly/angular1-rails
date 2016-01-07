class AddUserRefToOrderStatuses < ActiveRecord::Migration
  def change
    add_reference :order_statuses, :user, index: true
    add_foreign_key :order_statuses, :users
  end
end
