class Recharge < ActiveRecord::Base
  include Amountable

  amountable :amount, :bonus, :discount

  belongs_to :customer

  after_create do |record|
    ActiveRecord::Base.transaction do
      customer.balance += (record.amount+record.bonus)
      customer.discount = record.discount
      customer.is_member = customer.discount < 1.0
      customer.save!

      customer.orders.unpaid_and_pre.where(
        "discount > ?", customer.discount*100
      ).each do |order|
        order.update!(discount: customer.discount)
      end
    end
  end

end
