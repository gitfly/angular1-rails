class AddOrderIdToFriend < ActiveRecord::Migration
  def change
    add_column :friends, :order_id, :integer
    add_index :friends, :order_id
    Order.find_in_batches do |orders|
      orders.each do |o|
        f = Friend.where(id: o.friend_id).first
        f.update_attributes!(order_id: o.id) if f
      end
    end
  end
end
