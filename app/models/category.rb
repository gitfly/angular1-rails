class Category < ActiveRecord::Base
  acts_as_paranoid
  acts_as_nested_set counter_cache: :children_count, dependent: :delete_all

  validates_presence_of :name

  Classify = {
    "钱包": "钱包",
    "卡包": "钱包", 
    "钥匙包": "钱包", 
    "单肩包": "包",
    "双肩包": "包",
    "手提包": "包",
    "肩带": "包",
    "行李箱": "行李箱", 
    "鞋子": "鞋",
    "短靴": "鞋", 
    "长靴": "鞋",
    "过膝长靴": "鞋",
    "皮衣": "皮衣",
    "皮马甲": "皮衣",
    "皮草": "皮衣",
    "皮带": "皮带",
    "手表带": "手表带",
    "皮手套": "皮手套",
  }

  def title
    name
  end

  def record_id
    id
  end

  def edit
    false
  end

end
