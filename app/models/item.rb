class Item < ActiveRecord::Base
  acts_as_paranoid

  self.inheritance_column = nil

  has_many :orders
  belongs_to :customer
  # belongs_to :color
  has_many :technologies

  attr_accessor :handler_id, :show_type

  after_update :item_updated 

  Type = {
    "HandBag": "手提包", 
    "SingleShoulderBag": "单肩包",
    "BackPack": "双肩包", 
    "CosmeticBag": "化妆包", 
    "Wallet": "钱包",
    "CardBag": "卡包",
    "Belt": "皮带", 
    "Shoes": "鞋子",
    "FurClothing": "皮衣",
    "KeyCase": "钥匙包",
    "FurGlove": "皮手套", 
    "PhoneCase": "手机套", 
    "WatchBand": "手表带",
    "AnkleBoot": "短靴",
    "ThighBoot": "长靴",
    "ShoulderTape": "肩带", 
    "Fur": "皮草",
    "Hat": "帽子", 
    "Pimajia": "皮马甲", 
    "SuitCase": "行李箱", 
    "KneeBoot": "过膝长靴",
    "Others": "其他"
  }

  Scale = {
    "大包": 0, 
    "中包": 1, 
    "小包": 2
  }

  def show_color
    {name: color.name, value: color.value}
  end

  def show_type=(typeZh)
    self.type = Type.key(typeZh)
    # if self.type.blank?
      # msg = "invalid item show_type,\
      # item show_type must in (#{Type.values.join(', ')})"
      # self.errors.add(:type, msg)
      # raise ActiveRecord::RecordInvalid.new(self)
    # end
  end

  def show_type
    if type
      Type[type.to_sym]
    else
      ''
    end
  end

  def show_scale
    Item::Scale.key(scale).to_s
  end

  def order
    Order.where(item_id: self.id).first
  end

  def self.filter_by(params)
    primary_key = params.keys.first
    sql = [].tap do |arr|
      params.each do |k, v|
        arr << "#{k} like ?"
      end
    end.join(' and ')
    values = params.values.map{|v|  "%#{v}%"}
    self.where(sql, *values).
      where("#{primary_key} is not null and #{primary_key} != ''").
      group(primary_key).
      limit(20).
      order("count_#{primary_key} desc").
      count(primary_key).keys
  end

  private

    def item_updated
      order.logs.create!(
        handle_type: 'Update', 
        user_id: self.handler_id, 
        attrs: changes.keys.map{|attr| "item_#{attr}"}.join('|'),
        changed_values: self.changes
      ) if self.handler_id && changes.present?
      self.handler_id = nil
    end

end
