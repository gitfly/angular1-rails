class Refund < ActiveRecord::Base
  include Amountable

  after_create :caculate_order_final_price

  belongs_to :order
  amountable :amount

  scope :cancel, -> { where(rtype: 0) }
  scope :refund, -> { where(rtype: 1) }
  scope :compensate, -> { where(rtype: 2) }

  RType = {
    0 => "cancel",       #取消订单
    1 => "refund",       #退款
    2 => "compensate",   #赔付
  }

  private

    def caculate_order_final_price
      order.final_price = order.calculate_final_price
      order.save!
    end

end
