class ConsumptionRecord < ActiveRecord::Base
  belongs_to :customer, dependent: :destroy
  has_one :order

  has_and_belongs_to_many :orders

  PaymentMethod = {
    "会员卡": 0,
    "现金": 1, 
    "刷卡": 2, 
    "微信支付": 3,
    "支付宝支付": 4, 
    "银行转账": 5, 
    "使用朋友会员卡消费": 6,
  }

  RechargePM = {
    "现金": 0, 
    "刷卡": 1, 
    "微信支付": 2,
    "支付宝支付": 3, 
    "银行转账": 4
  }

  def amount
    raw_amount/100.0
  end

  def amount=(value)
    self.raw_amount = value * 100.0
  end

  def show_pm
    PaymentMethod.key payment_method
  end

end
