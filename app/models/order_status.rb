class OrderStatus < ActiveRecord::Base
  belongs_to :order
  belongs_to :user
  acts_as_paranoid
  scope :forward, -> { where(forward: true) }
  scope :backward, -> { where(forward: false) }

  before_save do |record|
    record.user_id or raise "you can not create order status without a user_id"
  end
  after_create :save_callback

  Status = {
    all:                             -1,                # 全部状态

    order_created:                    0,                # 已开单
    store_acknowledge_receipt:        1,                # 门店已收货

    sent_to_factory:                  2,                # 已送去修复中心
    factory_received:                 3,                # 修复中心已接收 

    adviser_sorted_out:               4,                # 顾问完成分拣(待诊断)
    diagnosed:                        5,                # 顾问完成诊断  
    photo_uploaded:                   6,                # 拍照完成    
    # blue_print_created:               7,                # 修复方案已生成
    # blue_print_sent:                  8,                # 修复方案已发送
    # blue_print_verified:              9,                # 修复方案已确认
    attach_into_storage:             10,                # 附件已入库

    repairing:                       11,                # 修复中(修复组接收)
    repaired:                        12,                # 修复已完成

    blue_print_tested:               13,                # 方案质检已通过
    effect_photo_uploaded:           14,                # 效果照片已上传
    effect_result_created:           15,                # 效果方案已发送顾问
    effect_result_sent:              16,                # 效果方案已发送顾客
    effect_result_confirmed:         17,                # 效果方案已确认

    repaired_into_storage:           18,                # 修复完成已入库
    # packaged:                        19,                # 包装完成

    delivery_manner_confirmed:       20,                # 已确认送货方式

    waiting_for_customer_receipt:    21,                # 等待顾客收货
    customer_receipt_confirmed:      22,                # 顾客已确认收货
  }

  def self.zh_statuses
    Status.keys.map{ |_status| I18n.t("order.status.#{_status}")}
  end

  def show_last_status
    I18n.t("order.status.#{Status.key(last_status)}")
  end

  def show_status
    I18n.t("order.status.#{Status.key(status)}")
  end

  def backward!
    update_attributes!(forward: false)
  end

  def self.filter_by_zh_status(zh_value)
    status = I18n.t('order.status').key(zh_value).try(:to_sym)
    status.blank? and return self.all
    filter_by_status OrderStatus::Status[status]
  end

  def self.filter_by_status(value)
    if value.to_i >= 0
      self.where("order_statuses.status = #{value}")
    else
      self.all
    end
  end

  private

    def save_callback
      ActiveRecord::Base.transaction do
        create_log
        status_change_where_confirm_delivery_manner
      end
    end

    def status_change_where_confirm_delivery_manner
      if status == Status[:delivery_manner_confirmed]
        o = order.customer.orders.where(
          status: Status[:packaged]
        ).where.not(id: order_id).first
        o.try(:goto_next_status, user_id)
      end
    end
    
    def create_log
      order.logs.create!(
        user_id: user_id,
        handle_type: 'StatusChange',
        changed_values: { "状态": [show_last_status, show_status] }
      )
    end
  
end
