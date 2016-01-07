class Customer < User
  include Amountable
  include CustomerDetailReport
  has_many :addresses, as: :addressable
  has_many :orders
  has_many :consumption_records
  has_many :items
  has_many :friends
  has_one :compensate
  has_many :settlements
  has_many :activity_codes
  has_many :recharges
  has_many :appointments

  validates_presence_of :name

  before_validation :set_password_and_order_id

  amountable raw_balance: :balance

  Discount = {
    0 => 1.00,
    3 => 0.88, 
    5 => 0.80, 
    8 => 0.75
  }

  Recharge = {
    "充值3000，打88折": 3000,
    "充值5000，打8折": 5000,
    "充值8000，打75折": 8000,
  }

  Source = {
    0 => "大众点评",
    1 => "微博", 
    2 => "朋友推荐", 
    3 => "微信"
  }

  Sensitivity = {
    0 => "中",
    1 => "高",
    2 => "特"
  }

  def show_sensitivity
    Sensitivity[sensitivity]
  end

  def show_phone
    phone.blank? and return ""
    p = phone
    p[3..6]='*'*4
    p 
  end

  def referrer
    friends.referrers.first
  end

  def orders_count
    orders.count
  end

  def recharge_total
    recharges.select('sum(amount)/100.0 as total').first.total || 0.0
  end

  def show_source
    Source[self.source]
  end

  def customer_type 
    if is_member
      "#{show_discount} 会员"
    else
      if orders.completed.exists?
        "老用户"
      else
        "新用户"
      end
    end
  end

  def discount
    dis = read_attribute(:discount).to_f
    dis.zero? ? 1.00 : dis
  end

  def show_discount
    if discount == 1.00
      "无折扣"
    else
      "#{(discount*100).to_i}折".delete('0')
    end
  end
  
  def recharge(params)
    ActiveRecord::Base.transaction do
      val = params[:amount].to_i/1000
      if Discount.key?(val)
        c = consumption_records.create!(
          amount: params[:amount].to_f, 
          payment_method: params[:payment_method].to_i,
          remark: params[:remark],
          recharge: true
        )
        self.update_attributes!(
          is_member: true,
          discount: Discount[val],
          balance: self.balance+params[:amount].to_f
        )
        return c
      end
    end
  end

  def balance_increase_by(val)
    self.update_attributes!(balance: self.balance+val)
  end

  def latest_order
    orders.where(cancel: false).order(created_at: :desc).limit(1).first
  end

  def earliest_order
    orders.where(cancel: false).order(created_at: :asc).limit(1).first
  end

  def consumption_times
    orders.where(cancel: false).count("distinct(date(created_at))")
  end

  def consumption_orders
    orders.where(cancel: false).count
  end

  def consumption_total_money
    orders.where(cancel: false).sum(:final_price)/100.00
  end

  def show_source_of_detail 
    if source == 2
      "#{Source[self.source]}——#{friends.referrers.first.try(:name)}"
    else
      Source[self.source]
    end
  end

  def recent_three_months_orders
    now = Time.now
    recent_three_months = (now - 90.days).beginning_of_day
    os = orders.where(cancel: false)
    os.where("created_at > '#{recent_three_months}' and created_at <= '#{now}'").count
  end

  def recent_address
    addresses.order(created_at: :desc).limit(1).first
  end

  def show_is_member
    return is_member ? "是" : "否"
  end

  def all_orders_count(next_status)
    if next_status  
      orders.where(cancel: false, status: ::OrderStatus::Status[next_status.to_s.to_sym]).count
    else
      orders.where(cancel: false).where.not(status: ::OrderStatus::Status[:complete]).count
    end
  end

  def orders_count_by_status
    [].tap do |arr|
      orders.order('status').group(:status).count.each do |status, count|
				s = I18n.t("order.status.#{OrderStatus::Status.key(status)}")
				arr << { status: s, count: count }
      end
    end
  end

  def orders_group_by_status
    {}.tap do |hash|
      orders.includes(:item).group_by(&:show_status_zh).each do |status, orders|
        hash[status] = orders.map do |order|
          {id: order.id, number: order.number, item_type: order.show_item_type}
        end
      end
    end
  end

  private

  def set_password_and_order_id
    self.password = SecureRandom.hex(4) unless self.password 
    self.store_id = 1
  end

end
