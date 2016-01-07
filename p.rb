names=  ["北京市", "上海市", "天津市", "广东省", "河北省", "河南省", "福建省", "安徽省", "浙江省", "重庆市", "山东省", "山西省", "陕西省", "黑龙江省", "湖北省", "湖南省", "四川省", "江苏省", "江西省", "辽宁省", "贵州省", "海南省", "吉林省", "内蒙古自治区", "宁夏回族自治区", "青海省", "西藏自治区", "新疆维吾尔自治区", "云南省", "甘肃省", "广西壮族自治区"]

# hash = {}
# names.each do |name|
#   hash[Province.find_by_name(name).id] = name
# end
# 
# puts hash
# # Province.destroy_all 
# # ActiveRecord::Base.connection.execute("TRUNCATE provinces")
# hash.each do |k, v|
#   p = Province.create(name: v)
# end
# 
# hash.each do |k, v|
#   p, _p = Province.where(name: v)
#   p.destroy
#   _p.update_attributes!(id: p.id)
# end
names.each_with_index do |name, i|
  Province.find_by_name(name).update_attributes!(created_at: Time.now+i.minutes)
end
