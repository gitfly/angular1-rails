class Friend < ActiveRecord::Base
  belongs_to :customer
  belongs_to :order

  after_save do |friend|
    order = friend.order
    orders = order.customer.orders
    orders.uncompleted.update_all(
      friend_id: id, delivery_manner: order.delivery_manner
    )
    Friend.where(order_id: orders.map(&:id)).update_all(
      name: name, phone: phone
    )
  end

  scope :referrers, -> { where("ftype = 0") }

  Types = {
    0 => "推荐", 
    1 => "代取货", 
    2 => "上门送货"
  }

  def show_type 
    Types[ftype]
  end

end
