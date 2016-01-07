class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_paranoid

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name

  has_attached_file :avatar, 
    default_url: 'images/girl.svg',
    styles: { :medium => "300x300>", :thumb => "100x100>" } 

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  belongs_to :store
  has_one :weixin_account
  
  has_many :access_tokens, dependent: :destroy, 
    class_name: 'Doorkeeper::AccessToken', foreign_key: :resource_owner_id

  has_many :order_logs
  has_many :settlements
  has_many :order_statuses

  before_save do |user|
    if user.email.blank?
      user.email = "#{user.phone}@baozheng.cc"
    end
  end

  scope :us, -> { where(type: Roles.values) }

  Roles = {
    "管理员":             "Admin",
    "经理":               "Manager",
    "财务":               "Finance",
    "匠人":               "Worker",
    "前台":               "FrontDesker",
    "方案组":             "Solutionist",
    "顾问":               "Counselor",
    "顾问主管":           "CounselorManager",
    "修复中心负责人":     "WorkerManager",
    "品控":               "Inspector",
    "修复分拣":           "RepairSorter",
    "库管":               "Warehouse",
    "客服":               "CustomerService",
    "客服主管":           "CustomerServiceManager",
    "运营":               "Operator",
    "取送":               "Courier"
  }

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def admin?
    type == 'Admin'
  end

  def show_gender
    gender ? "男" : "女"
  end

  def call_name
    first_name = name 
    if name && name.chars.first.match(/^[\u4e00-\u9fa5]+$/)
      first_name = name.chars.first
    end
    if gender
      "#{first_name}同学"
    else
      "#{first_name}MM"
    end
  end

  def gender_attr
    gender ? 'boy' : 'girl'
  end

  def avatar_url
    avatar.url(:thumb)
  end

  def show_type
    Roles.key(type).to_s 
  end

  def front_end_attributes 
    {}.tap do |hash|
      %W(id name type phone weixin email weixin_nickname).each do |attr|
        hash[attr] = send(attr)
      end
    end
  end

  def leftbar_items(params)
    [].tap do |arr|
      %w(leftbar_types leftbar_statuses leftbar_users).each do |method|
        if self.respond_to?(method)
          data = self.send(method, params)
          data.present? and arr << data
        end
      end
    end
  end
end
