class Settlement < ActiveRecord::Base
  include Amountable
  acts_as_paranoid
  belongs_to :customer
  has_many :orders
  belongs_to :user
  has_many :pay_records
  has_many :activity_codes

  amountable :amount

  def pms
    pay_records.map(&:show_pm).join(" | ")
  end

  def self.pay(params, handler)
    order_ids = params.delete(:order_ids)
    Order.where(id: order_ids, paid: true).present? and return false
    pay_records = params.delete(:pay_records).map do |pr|
      ActionController::Parameters.new(pr).permit(
        :pm, :amount, :content, :settlement_id, :member_id
      )
    end
    ActiveRecord::Base.transaction do
      settlement = create!(params.merge(
        user_id: handler.id, 
        user_name: handler.name
      ))
      settlement.pay_records.create!(pay_records)

      total = settlement.pay_records.where(pm: 0).
        select('sum(amount)/100.0 as total').first.total.to_f

      settlement.customer.balance_increase_by(-total)

      Order.where(id: order_ids).each do |order|
        order.update_attributes!(
          paid: true,
          settlement_id: settlement.id
        )
      end
      return settlement
    end
  end
  
  def self.filter_by_date(from, to=Time.zone.now)
    self.where(
      "created_at > :from and created_at <= :to", 
      from: from.beginning_of_day, to: to.end_of_day
    )
  end
end
