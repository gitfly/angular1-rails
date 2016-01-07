module Pricable
  extend ActiveSupport::Concern

  included do
    before_update :set_price, if: Proc.new { |order| 
      order.service_ids_changed? || 
      order.activity_id_changed? || 
      order.discount_changed?
    }
  end

  def discount
    _discount = read_attribute(:discount)
    customer_discount = customer.try(:discount)||1.0
    _discount ? _discount.to_f/100.0 : customer_discount
  end

  def discount=(dis)
    write_attribute(:discount, dis*100)
  end

  def original_price
    if service_ids_changed?
      services.pluck(:price).sum
    else
      @original_price ||= services.pluck(:price).sum
    end
  end

  def discount_price
    original_price * discount
  end

  def cancel_price
    cancel ? 0.0 : original_price
  end
  
  def ac_price
    activity ? activity.price_for(self) : original_price
  end

  def cancel_amount
    cancel ? refunds.select{|r| r.rtype==0}.first.try(:amount).to_f : 0.0
  end

  def refund_amount
    refunded ? refunds.select{|r| r.rtype==1}.first.try(:amount).to_f : 0.0
  end

  def compensate_amount
    compensated ? refunds.select{|r| r.rtype==2}.first.try(:amount).to_f : 0.0
  end

  def expend_amount
    if cancel || refunded || compensated
      refunds.select("sum(amount)/100.0 as total").first.try(:total).to_f
    else
      0.0
    end
  end

  def final_discount
    price.to_f.zero? and return 1.00
    (final_price/price.to_f).round(2)
  end

  def real_price
    [discount_price, ac_price].min
  end

  def calculate_final_price
    real_price - expend_amount
  end

  def set_price
    self.act_price = ac_price
    self.price = original_price
    self.final_price = calculate_final_price
  end

  def update_price
    set_price
    save!
  end
end
