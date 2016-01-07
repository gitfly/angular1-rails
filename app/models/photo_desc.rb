class PhotoDesc < ActiveRecord::Base
  has_many :photos, :foreign_key => 'desc_id'
  has_many :tags, class_name: "DescTag"

  DType = {
    0 => "症状描述", 
    1 => "工艺描述",
    2 => "效果描述",
    3 => "效果方案话术"
  }
end
