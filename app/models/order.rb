require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/ascii_outputter'
require 'barby/outputter/html_outputter'
require 'barby/outputter/png_outputter'

class Order < ActiveRecord::Base

  include Pricable,
          OrderData, 
          Amountable, 
          WarehouseFlow,
          OrderLoggable, 
          OrderItemReport, 
          AppointmentInfo, 
          FetchDeliveryReport

  attr_accessor :service_name, :handler_id

  belongs_to :item
  belongs_to :store
  belongs_to :activity
  belongs_to :customer
  belongs_to :settlement
  belongs_to :act_record
  belongs_to :appointment
  
  has_one  :friend
  has_one  :express, as: :expressable
  has_one  :refund, -> { where(rtype: 1) }
  has_one  :compensate, -> { where(rtype: 2) }, class_name: "Refund"
  has_one  :cancel_record, -> { where(rtype: 0) }, class_name: "Refund"

  has_many :refunds
  has_many :overdues
  has_many :technologies
  has_many :activity_codes
  has_many :photos, as: :photoable
  has_many :quality_testings, through: :technologies
  has_many :photo_symptoms, through: :photos, source: "symptoms"
  has_many :logs, foreign_key: 'order_id', class_name: 'OrderLog'
  has_many :statuses, :foreign_key => 'order_id', :class_name => "OrderStatus"

  # has_and_belongs_to_many :templates, class_name: "SoluTemplate"

  acts_as_paranoid
  amountable :act_price, :final_price

  has_attached_file :barcode, 
    :styles => {:thumb => "500x200>" }, 
    :default_url => "/images/:style/missing.png"
  validates_attachment :barcode, 
    :size => { :in => 0..10.kilobytes },
    :content_type => { :content_type => "image/png" }
  
  validates :discount, inclusion: { in: 0.0..1.0 }

  before_create  :generate_number, unless: :number
  before_create  :set_init_status, 
    if: Proc.new { |order| order.pickup_manner != PickupManner[:包拯上门取] }

  before_update  :update_created_at, if: :pre_changed?

  after_save     :save_callback
  after_create   :after_create_callback


  scope :pre, -> { where(pre: true) }
  scope :urgent, -> { where(urgent: true) }
  scope :unpaid_and_pre, -> { where(paid: false) }
  scope :paid, -> { where(paid: true, pre: false, cancel: false) }
  scope :unpaid, -> { where(paid: false, pre: false, cancel: false) }
  scope :canceled, -> { where(cancel: true) }
  scope :uncanceled, -> { where(cancel: false) }
  scope :reverse_order, -> { order("created_at desc") }
  scope :today, -> { where{ created_at >= Time.zone.today.beginning_of_day } }
  scope :this_week, -> { where{ created_at >= Time.zone.now.at_beginning_of_week} }
  scope :yesterday, -> { where{ created_at >= Time.zone.yesterday.beginning_of_day } }
  scope :this_month, -> { where{ created_at >= Time.zone.now.at_beginning_of_month } }
  scope :before_today, -> { where{ created_at < Time.zone.now.beginning_of_day } }
  scope :status_change_before_today, -> { where{ status_updated_at < Time.zone.now.beginning_of_day } }
  scope :late, -> {
    where("finish_date < '#{Date.today+2.days}'").
    where("status < #{OrderStatus::Status[:delivery_manner_confirmed]}")
  }
  scope :completed, -> { 
    where(pre: false, status: OrderStatus::Status[:customer_receipt_confirmed], cancel: false) 
  }
  scope :uncompleted, -> { where("status != #{OrderStatus::Status.values.last}").uncanceled }
  scope :has_attachment, -> {where.not(attachment:[nil, ""])}
  scope :order_by_customer_name, -> {order("convert(users.name USING gbk) COLLATE gbk_chinese_ci asc")}
  scope :fetch_delivery, -> { where("status = 0 and pickup_manner =1 or status = 21 and delivery_manner = 2") }
  scope :need_fetch, -> { where("status = 0 and pickup_manner =1") }
  scope :need_delivery, -> { where("status = 21 and delivery_manner = 2") }

  OrderStatus::Status.except(:all).each do |k, v|
    scope k, -> { where(pre: false, status: v) }
  end

  Pre = {
    "预订单": true,
    "正式订单": false
  }
  PickupManner = {
    "亲自来店": 0,
    "包拯上门取": 1,
    "快递寄来": 2,
  }
  DeliveryManner = {
    "顾客来店取": 0,
    "朋友来店代取": 1,
    "包拯上门送": 2,
    "快递": 3
  }
  Urgent = {
    true => "加急",
    false => "不加急"
  }
  SearchType = {
    all: "全部", 
    pre: "预",
    unpaid: "未支付", 
    paid: "已支付",
    urgent: "加急",
    late: "超期", 
    canceled: "已取消"
  }
  DeliveryTroubleType = {
    "联系不上":0,
    "客户改期":1,
    "客户取消":2
  }


  def late
    if self.finish_date
      self.finish_date-2.days < Date.today && self.status < OrderStatus::Status[:packaged].to_i
    else
      false
    end
  end

  def completed?
    status == OrderStatus::Status[:customer_receipt_confirmed]
  end

  def cancel_refund
    cancel and refunds.where(rtype: 0).first
  end

  def refund
    refunded and refunds.where(rtype: 1).first
  end

  def compensate
    compensated and refunds.where(rtype: 2).first
  end

  def self.order_by(order_by, order_desc=true)
    orders = self.all
    order_by.blank? and return orders
    orders = self.joins{customer} if order_by.split('.').first == 'users'
    orders.order("#{order_by} #{'desc' if order_desc=='true'}")
  end

  def self.filter_by_date_range_or_scope(params)
    if params[:start_date].present? || params[:end_date].present?
      self.filter_by_date(params[:start_date], params[:end_date])
    else
      self.send(params[:date_scope]||:all)
    end
  end

  def self.filter_by_date(from=nil, to=nil)
    to.blank? || from.blank? and return self.all
    from, to = [from, to].map{|val| Time.parse(val.to_s)}
    self.where(
      "orders.created_at > :from and orders.created_at <= :to",
      from: from.beginning_of_day, to: to.end_of_day
    )
  end

  def self.filter_order_by_type(type)
    type.blank? and return self.all
    orders = self.send(SearchType.key(type))
    type.to_s == '已取消' and return orders
    orders.uncanceled
  end

  def self.filter_by_handler(name)
    uid = User.where("type != 'Customer'").where(name: name).first.try(:id)
    if uid
      self.joins(:statuses).where(
        "order_statuses.forward=true and order_statuses.user_id = #{uid}"
      )
    else
      self.all
    end
  end

  def self.search_type_counts
    values = {}.tap do |hash|
      SearchType.map do |key, v|
        hash[v] = if key.to_s == 'canceled'
                    send(key).count
                  else
                    send(key).uncanceled.count
                  end
      end
    end
    { keys: SearchType.values, values: values, type: 'type' }
  end

  def self.status_counts(*_keys)
    _keys.blank? and _keys = OrderStatus::Status.keys

    keys = _keys.map{|key| I18n.t("order.status.#{key}")}
    counts = self.group(:status).count
    values = {}.tap do |hash|
      OrderStatus::Status.slice(*_keys).each do |k, v|
        hash[I18n.t("order.status.#{k}")] = counts[v].to_i
      end
      hash[I18n.t("order.status.all")] = self.count
    end
    { keys: keys, values: values, type: 'status' }
  end

  def self.filter_by_keyword(keyword)
    keyword.blank? and return self.all
    self.unscoped.where(deleted_at: nil).joins{customer}.where {
      (number =~ "%#{keyword}%") |
      (customer.name =~ "%#{keyword}%") |
      (customer.phone =~ "%#{keyword}%")
    }
  end

  def self.find_by_encrypted_id(en_id)
    en_id.present? or return nil
    id_or_number = (Encryption.decode(en_id.to_s).first.try('%', 100000000))
    where("id = #{id_or_number} or number = #{id_or_number}").first 
  end

  def encrypted_id
    Encryption.encode(100000000+id)
  end

  def barcode_blob
    Barby::Code128B.new(encrypted_id).to_png(xdim: 3, margin: 0)
  end

  def barcode_html
    Barby::Code128B.new(encrypted_id).to_html
  end

  def barcode_url
    barcode.url(:original)
  end

  def thumb_barcode_url
    barcode.url(:thumb)
  end

  def before_template
    SoluTemplate.before.first
    # templates.first
  end

  def after_template
    SoluTemplate.after.first
    # templates.last
  end

  def show_front
    photos.unscoped.where(
      front: true, 
      photoable_type: self.class,
      photoable_id: self.id
    ).last.try(:original_url)
  end

  def show_min_front
    photos.unscoped.where(
      front: true, 
      photoable_type: self.class,
      photoable_id: self.id
    ).last.try(:thumb_url)
  end

  def show_reverse
    photos.unscoped.where(
      front: true, 
      photoable_type: self.class,
      photoable_id: self.id
    ).last.try(:original_url)
  end

  def first_original_photo
    photos.first.try(:original_url)
  end

  def first_min_photo
    photos.first.try(:thumb_url)
  end

  def use_activity_by(handler_id, activity_id)
    update_attributes!(activity_id: activity_id)
    logs.create!(
      handle_type: 'Activity', 
      user_id: handler_id,
      changed_values: all_changed
    ) unless all_changed.blank?
  end

  def create_activity_codes(codes = [])
    codes.blank? and return

    activity_codes.destroy_all
    activity_codes.create! codes.map { |code| 
      { code: code, activity_id: self.id }
    }
    reload.update_price
  end

  def show_activity_info
    activity or return nil
    if activity.atype == 1
      "使用#{groupon_codes_count}张券：#{act_price}"
    else
      act_price
    end
  end

  def show_activity_name
    activity ? activity.show_name : "无活动"
  end

  def available_activities
    type = Activity::ItemType.key(item.type)

    Activity.where(
      "item_type = 0 or item_type like ?", "%#{type}%"
    ).where(
      "start_date <= :start and end_date >= :end ",
      start: Date.today,
      end: self.created_at.to_date
    )
  end

  def fetch_address
    if fetch_address_id
      Address.find(fetch_address_id)
    else
      customer and customer.addresses.last
    end
  end

  def delivery_address
    if delivery_address_id
      Address.find(delivery_address_id)
    else
      fetch_address
    end
  end

  def show_item_type
    item.try(:show_type)
  end

  def show_brand
    item.try(:brand)
  end

  def show_color
    item.try(:color)
  end

  def show_style
    item.try(:style)
  end

  def need_pickup?
    pickup_manner == PickupManner["包拯上门取"]
  end

  def need_delivery?
    delivery_manner == 2
  end

  def show_delivery_manner
    DeliveryManner.key(delivery_manner).to_s
  end

  def show_pickup_manner
    PickupManner.key(pickup_manner).to_s
  end

  def show_paid
    paid ? "已付款" : "未付款"
  end

  def services
    Service.where(id: service_ids.split(','))
  end

  def show_service
    services.pluck(:name).join(Service::NameSeparator)
  end

  alias service_name show_service

  def service_name=(s_name)
    s_names = s_name.split(Service::NameSeparator)
    self.service_ids = Service.where(name: s_names).pluck(:id).join(',')
  end

  def service_ids
    read_attribute(:service_ids).split(',')
  end

  # def attachment
  #   read_attribute(:attachment).try(:split, ',')
  # end

  def show_attachment
    read_attribute(:attachment)
  end

  def show_part
    read_attribute(:part)
  end

  def finish_date
    date = read_attribute(:finish_date)
    if pre
      date
    else
      date or created_at.to_date+15.days
    end
  end

  def show_pickup_date
    "#{fetch_date} #{fetch_date_detail}"
  end

  def fetch_date_detail
    "#{fetch_hour_start}-#{fetch_hour_end}"
  end

  def delivery_date_detail
    "#{delivery_hour_start}-#{delivery_hour_end}"
  end

  def price
    read_attribute(:price).to_f
  end

  def show_delivery_date
    if delivery_date.present? && delivery_date_start.present? && delivery_date_end.present?
      "#{delivery_date} #{delivery_date_start}点到#{delivery_date_end}点"
    else
      "#{delivery_week} #{delivery_day}"
    end
  end

  def show_status
    OrderStatus::Status.key(status).to_s
  end

  def show_status_zh
    if show_status.blank?
      "暂无状态"
    else
      I18n.t("order.status.#{show_status}")
    end
  end

  def show_next_status
    OrderStatus::Status.key(next_status).to_s
  end

  def show_next_status_zh
    if show_next_status.blank?
      "暂无状态"
    else
      I18n.t("order.status.#{show_next_status}")
    end
  end

  def next_status
    next_key = OrderStatus::Status.values.index(self.status).to_f + step_length
    OrderStatus::Status.values[next_key]
  end

  def step_length
    if ::OrderStatus::Status[:photo_uploaded] == status && part.blank?
      2
    else
      1
    end  
  end

  def last_status
    last_key = OrderStatus::Status.values.index(self.status).to_f - step_length
    last_key = 1 if last_key.zero?
    OrderStatus::Status.values[last_key]
  end

  def goto_next_status(hid=nil)
    self.handler_id = hid if hid
    update_status_to next_status
  end

  def auto_goto_next_status
    update_status_to next_status, true
  end

  def back_to_last_status(hid=nil)
    self.handler_id = hid if hid
    order_status = update_status_to(last_status)
    statuses.order('id desc').limit(2).update_all(forward: false)
    order_status
  end

  def update_status_by_name(status_name)
    update_status_to(OrderStatus::Status[status_name.to_sym])
  end

  def update_status_to(_status, auto_distribute = false)
    handler_id or raise "you can not update order status without a handler_id"
    (_status.nil? || (_status == status)) and return

    ActiveRecord::Base.transaction do
      last_status = self.status
      update!(
        status: _status, 
        auto_distribute: auto_distribute, 
        status_updated_at: Time.zone.now
      )
      order_status = self.statuses.create!(
        status: _status, last_status: last_status, user_id: handler_id
      )
    end
  end

  def self.filter_by_zh_status(zh_value)
    status = I18n.t('order.status').key(zh_value).try(:to_sym)
    status.blank? and return self.all
    filter_by_status OrderStatus::Status[status]
  end

  def self.filter_by_status(value)
    if value.to_i >= 0
      self.where(status: value)
    else
      self.all
    end
  end
  
  def item_parts
    parent = Category.where(name: show_type, depth: 0).first
    if parent
      parent.children
    else
      []
    end
  end

  def show_urgent
    urgent ? "加急" : "不加急"
  end

  def show_created_at
    created_at.try(:strftime, '%y-%m-%d')
  end

  def show_number
    l = number.to_s.length
    "#{Date.parse(number.to_s[0..7]).to_s}-#{number.to_s[8..l-1]}"
  end

  def self.generate_order_number(customer_orders_count)
    "#{Time.now.strftime('%Y%m%d%H%M%S')}#{customer_orders_count}"
  end

  def consumption
    services.map(&:price).sum*customer.discount
  end

  # def created_by(user)
  #   logs.create!(
  #     handle_type: 'Create',
  #     user_id: user.id,
  #   )
  # end

  def type
    item.try(:type)
  end

  def show_type
    Category::Classify[show_item_type.try(:to_sym)]
  end

  def show_overdues
    overdues.order(created_at: :desc)
  end

  def show_pms
    settlement.try(:pms) || ''
  end

  def recent_overdue
    overdues.order(created_at: :desc).limit(1).first
  end

  def show_overdue_times
    if recent_overdue && recent_overdue.expected_date < Time.now.beginning_of_day
      overdues.length + 1
    else
      1
    end
  end

  def show_remain_money
    if paid || status == OrderStatus::Status[:waiting_for_pickup]
      0.00
    else
      final_price
    end
  end

  def show_state
     OrderStatus::Status.key(status).to_s
  end

  def abnormal_info
    logs.where(handle_type: "Abnormal").last
  end

  def last_handler_for_status(status)
    statuses.where( status: OrderStatus::Status[status.try(:to_sym)]).last.try(:user)
  end

  def self.status_number(zh_status)
    OrderStatus::Status[I18n.t("order.status").key(zh_status)]
  end

  def status_handler
    self.statuses.
      forward.
      where("order_statuses.status = #{status}").
      order("order_statuses.id desc").
      joins(:user).
      select("users.name as user_name").
      first.try(:user_name)
	end

  def create_delivery_express params
    Express.create(
      expressable: self,
      number: params[:express_number],
      company_type: ::Express::CompanyType[:顺丰速运],
      cash_on_delivery: false
    )
  end

  def update_delivery_trouble params
    update_attributes!(
      delivery_trouble: true, 
      delivery_trouble_type: Order::DeliveryTroubleType[params[:delivery_trouble_type].to_sym],
      delivery_trouble_desc: params[:delivery_trouble_desc]
    )
  end

  def last_unqualified
    quality_testings.where(qualified: false).last
  end

  def current_technology
    technologies.last
  end

  def last_quality_testing_passed
    last_test = quality_testings.last
    last_test.present? && last_test.technology_id == technologies.last.id && last_test.qualified
  end

  def has_no_attachment
    attachment.blank?
  end

  private

    def update_created_at
      self.created_at = Time.now
    end

    # only set all_changed attributes 
    def save_callback
      self.all_changed ||= {}

      self.changes.except(*%w(
        updated_at fetch_date_detail delivery_date_detail
      )).each do |k, v|

        value = case k
                when 'urgent'
                  v.map{|val| Urgent[val]}
                when 'service_ids'
                  service_ids_changes(k, v)
                when 'price'
                  v.map(&:to_f)
                when 'discount'
                  [v.first.to_f/100.0, v.last]
                when 'pickup_manner'
                  v.map{|val| PickupManner.key(val)}
                when 'delivery_manner'
                  v.map{|val| DeliveryManner.key(val)}
                when 'pre'
                  v.map{|val| Pre.key(val)}
                when 'activity_id'
                  activity_id_changes(v)
                when /final_price|act_price/
                  v = [v.first.to_f/100.0, v.last]
                when /fetch_date|delivery_date/
                  values = format_changed_values(v)
                  old_value = values.first.to_s << send("#{k}_detail_was").to_s
                  new_value = values.last.to_s << send("#{k}_detail").to_s
                  [old_value, new_value]
                when /fetch_address_id|delivery_address_id/
                  v.map{|val| Address.where(id: val).first.try(:show_address)}
                else
                  format_changed_values(v)
                end

        changed_key = I18n.t("activerecord.attributes.order_log.#{k}")
        self.all_changed[changed_key] = value

      end if self.changed?
    end

    def format_changed_values(values)
      values.map do |val|
        case val
        when Date
          val.strftime("%m月%d日")
        when Time
          val.strftime("%m月%d日%H点%M分")
        else
          val
        end
      end
    end

    def value_change_for_attrubtues(*attrs)
      attrs.map do |attr|
        self.send(attr) != self.class.find(self.id).send(attr)
      end.any?
    end

    def activity_id_changes(values)
      values.map do |act_id|
        act = Activity.where(id: act_id).first
        act.try(:show_name) || "无活动"
      end
    end

    def service_ids_changes(k, values)
      original_price = Service.where(id: values.first.split(',')).pluck(:name).join('，')
      new_price = Service.where(id: values.last).pluck(:name).join('，')
      [original_price, new_price]
    end

    def generate_number
      count = customer.orders.uncompleted.count
      self.number = self.class.generate_order_number(count)
    end

    def set_init_status
      self.status = OrderStatus::Status[:store_acknowledge_receipt]
      self.status_updated_at = Time.zone.now
    end

    def after_create_callback
      _barcode = Barcode.where(number: number).first
      if _barcode.blank?
        store_barcode
      else
        self.barcode = _barcode.barcode
      end
      create_template_and_item
    end

    def store_barcode
      path = "/tmp/barcode#{Time.now.to_i}#{id}.png"
      File.open(path, 'w') do |f| 
        f.write barcode_blob
      end
      File.open(path, 'r') do |f|
        self.update_attributes! barcode: f
      end
      FileUtils.rm_f(path)
    end
    
    def create_template_and_item
      # before = SoluTemplate.rand_template(true)
      # after = SoluTemplate.rand_template(false)
      # if before && after
      #   templates << before
      #   template << after
      # else
      #   raise "please create SoluTemplate first"
      # end
      item = self.create_item!
      self.update_attributes!(item_id: item.id)
    end

end
