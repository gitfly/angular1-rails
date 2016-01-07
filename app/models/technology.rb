class Technology < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  has_many :quality_testings

  scope :unrepeated, -> { where(repeated: false) }
  scope :repairings_of_user, ->(user_id){
    Technology.joins(
      "left join quality_testings on technologies.id = quality_testings.technology_id"
    ).joins(:order).where(
      "orders.blue_print_passed != 0 or orders.blue_print_passed is null"
    ).where(
      user_id: user_id,
      substituted: false
    ).where("quality_testings.id is null or quality_testings.qualified = 0").distinct(id: true)
  }
  scope :completed_of_user_today, ->(user_id){
    QualityTesting.joins(:technology, :order)
    .where("date(quality_testings.created_at) = date(now())")
    .where("orders.blue_print_passed != 0 or orders.blue_print_passed is null")
    .where(qualified: true)
    .where(
      :technology => {user_id: user_id}
    )
  } 
  after_create do |tech|
    self.class.where(
      order_id: self.order_id, ttype: self.ttype
    ).where("id != #{self.id}").update_all(repeated: true)
  end

  TType = {
    "缝补": 0,
    "边油": 1, 
    "清洗": 2, 
    "保护": 3, 
    "上色": 4, 
    "保养": 5,
    "擦拭": 6
  }

  def user_name
    user.try(:name)
  end

  def at_working
    self.quality_testings == nil or self.quality_testings.last.qualified == false
  end

  def today_completed
    quality_testing = quality_testings.last
    if quality_testing
      quality_testing.created_at.today? and quality_testing.qualified
    else
      false
    end
  end

  def approved
    quality_testing = quality_testings.last
    if quality_testing
      quality_testing.qualified
    else
      false
    end
  end

  def last_unqualified_quality_testings
    quality_testings.where(qualified: false).last
  end

  def show_ttype
    TType.key(ttype)
  end

  def show_end_time
    end_time.try(:strftime, '%m-%d %H:%M')
  end

  def show_start_time 
    created_at.try(:strftime, '%m-%d %H:%M')
  end

  def duration
    end_time or return 0.0
    ((end_time - created_at)/60.0).round(2)
  end
end
