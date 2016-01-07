class PayRecord < ActiveRecord::Base
  include Amountable

  belongs_to :settlement
  amountable :amount


  before_create do | record|
    if pm == ::ConsumptionRecord::PaymentMethod[:使用朋友会员卡消费] 
      if member_id
        payer = Customer.find(member_id)
        if payer.balance < amount
          raise "payer has not enough money in member card"
        end
        payer.balance_increase_by(-amount)
      else
        raise "can not find payer by member_id" 
      end  
    end
  end

  def show_pm
    if pm == ::ConsumptionRecord::PaymentMethod[:使用朋友会员卡消费]
      if member_id
        customer_name = Customer.find(member_id).try(:name)   
      end
    end
    if customer_name
      "#{ConsumptionRecord::PaymentMethod.key pm}--#{customer_name}"
    else
      ConsumptionRecord::PaymentMethod.key pm
    end
  end
  
  def self.filter_by_date(from, to=Time.zone.now)
    self.where(
      "created_at > :from and created_at <= :to", 
      from: from.beginning_of_day, to: to.end_of_day
    )
  end
end
