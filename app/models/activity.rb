class Activity < ActiveRecord::Base
  include Amountable

  has_many :orders
  has_many :activity_codes
  scope :available, -> { where("start_date <= :date and end_date >= :date", date: Date.today) }

  amountable :real_income, :original_price

  ItemType = {
    0 => 'All',
    1 => 'Wallet', 
    2 => 'HandBag',
    3 => 'SingleShoulderBag',
    4 => 'BackPack',
    5 => 'Belt',
    6 => 'Shoes',
    7 => "FurClothing",
    8 => "KeyCase",
    9 => "CardBag", 
    10 => "FurGlove", 
    11 => "WatchBand", 
    12 => "AnkleBoot",
    13 => "ThighBoot", 
    14 => "KneeBoot",
    15 => "Pimajia",
    16 => "ShoulderTape",
    17 => "SuitCase", 
    18 => "Fur",
    19 => "Hat", 
    20 => "CosmeticBag", 
    21 => "PhoneCase",
    22 => "Others"
  }

  DiscountManner = {
    0 => "discount",
    1 => "minus"
  }

  AType = {
    0 => "Normal",
    1 => "Groupon",
    2 => "Coupon",
    3 => "QuotaGroupon",
    10 => "SpecialCoupon"
  }

  def amount
    read_attribute(:amount).to_f
  end

  def show_atype
    case atype
    when 0
      "普通活动"
    when 1
      "团购"
    when 2
      "优惠券"
    when 3
      "定额团购"
    else
      "特殊优惠"
    end
  end

  def show_coupon
    if atype == 0 || atype==10
      if discount_manner == 0
        "打#{amount.to_s.gsub('0', '')}折"
      else
        "直接减免#{amount}元"
      end
    elsif atype == 1
      "#{amount}抵#{original_price}"
    elsif atype == 3
      "全部#{amount}元"
    end
  end

  def show_addup
    if addup
      "可与会员折扣叠加"
    else
      "不可与会员折扣叠加"
    end
  end

  def item_types
    return [] unless item_type
    return ["全部物品"] if item_type.try(:match, '0')
    item_type.split(",").map do |t|
      Item::Type[ItemType[t.to_i].try(:to_sym)]
    end
  end

  def price_for(order)
    price = addup ? order.discount_price : order.original_price

    case atype
    when 1
      price - order.groupon_codes_count * original_price
    when 3
      amount
    else
      caculate_by_discount(price)
    end
  end

  def caculate_by_discount(price)
    if discount_manner == 0
      price * amount/100.0
    else
      if consume_add_up == 1
        price - amount
      else
        price - (amount/consume_add_up)
      end
    end.round(2)
  end

  def show_name
    "#{name}(#{'叠加' if addup}#{show_coupon})"
  end

  def show_item_type
    item_types.join(', ')
  end

  def available_for?(order)
    item_type.to_i.zero? and return true
    item_types.include?(order.show_item_type)
  end

  def apply_to(params)
    unless params[:handler_id] 
      raise "you cannot apply an ativity to order without an handler_id"
    end
    
    orders = Order.where(id: params[:order_ids])
    ActiveRecord::Base.transaction do
      orders.map do |o|
        o.create_activity_codes(params[:activity_codes])
        o.use_activity_by(params[:handler_id], id)
      end
    end
  end
end
