class Appointment < ActiveRecord::Base
  belongs_to :customer
  has_many :orders
  has_many :addresses, as: :addressable
  has_many :expresses, as: :expressable

  attr_accessor :address

  scope :door_type, -> { where(atype: 0) }
  scope :express_type, -> { where(atype: 1) }

  scope :cancel, -> { where(cancel: true) }
  scope :trouble, -> { where(trouble: true, cancel: false) }
  scope :troubled, -> { where(trouble: true, cancel: false) }
  scope :finished, -> { where(finished: true, trouble: false, cancel: false) }
  scope :unfinished, -> { where(finished: false, trouble: false, cancel: false) }
  scope :before_today, -> { where{ created_at < Time.zone.now.beginning_of_day } }

  TroubleType = {
    "联系不上":0,
    "客户改期":1,
    "客户取消":2
  }

  CancelType = {
    "联系不上":0,
    "包拯取消":1,
    "客户取消":2
  }

  Atype = {
    "上门": 0,
    "快递": 1
  }

  def association_obj
    if atype.try(:zero?)
      addresses.last
    else
      expresses.last
    end
  end

  def show_address
    atype.try(:zero?) ? addresses.last.try(:show) : nil
  end

  def express_number
    express.try(:number)
  end

  def express_name
    express.try(:company_name)
  end

  def express
    expresses.last unless atype.try(:zero?)
  end

  def address
    addresses.last if atype.try(:zero?)
  end

  def show_express
    atype.try(:zero?) ? expresses.last.try(:show) : nil
  end

  def show_trouble_type
    TroubleType.key(trouble_type)
  end

  def show_cancel_type
    CancelType.key(cancel_type)
  end

  def self.create_with_asso(params)
    customer = Customer.where(
      phone: params[:phone]
    ).first_or_create!(
      Customer.permit(params)
    )

    WeixinAccount.where(code: params[:code]).first.
      try(:update_attributes!, {user_id: customer.id})

    appointment = customer.appointments.where(Appointment.permit(params)).first_or_create!

    obj = if appointment.atype.try(:zero?)
            appointment.addresses.where(
              Address.permit(params[:address])
            ).first_or_create!
          else
            appointment.expresses.where(
              Express.permit(params[:express])
            ).first_or_create!
          end

    [customer, appointment, obj]
  end

  def update_with_asso(params)
    update!(Appointment.permit(params))
    if atype.try(:zero?)
      association_obj.update!(Address.permit(params[:address]))
    else
      association_obj.update!(Express.permit(params[:express]))
    end
    [customer, association_obj]
  end

  def date_detail_end
    value = read_attribute(:date_detail_end) 
    value.blank? ? '18:00' : value
  end

  def date_detail_start
    value = read_attribute(:date_detail_start) 
    value.blank? ? '10:00' : value
  end

  def show_date
    date.nil? ? '' : date.strftime(
      "%m-%d (#{date_detail_start}-#{date_detail_end})"
    ).gsub(/^0/, '')
  end

  def fetch_finished
    self.update_attributes!(finished: true)
  end

  def self.available_dates(start_date=Date.today)
    delivery_dates = Order.where(delivery_manner: 2).
      where("delivery_date > :date", date: start_date).
      group("delivery_date").count
    pickup_dates = Order.where(pickup_manner:1).
      where("fetch_date > :date", date: start_date).
      group("fetch_date").count

    [].tap do |dates|
      ((start_date+1)..(start_date+11.days)).each do |date|
        limit = (date.wday == 3 || date.wday == 5) ? 15 : 30
        total = pickup_dates[date].to_i + delivery_dates[date].to_i

        # dates << {date: date.strftime("%Y年%m月%d日"), total: total} if total <= limit
        dates << date if total <= limit
        dates.length == 5 and break
      end
    end
  end
end
