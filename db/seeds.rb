# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

UserTypes = %w(Admin Customer Worker)

BagBrand = %w(路易-威登LV 香奈儿Chanel 古琦欧-古琦Gucci 圣大保罗Polo 普拉达Prada 寇兹Coach 鳄鱼Lacoste 达芙妮Daphne 耐克Nike 百丽BELLE)
ShoeBrand = %w(芬迪 古驰 迪奥 圣罗兰 费拉格慕 夏奈尔 普拉达 蒂埃利·爱马仕 都彭 登喜)
BeltBrand = %w(古琦欧-古琦Gucci 路易-威登LV 登喜路Dunhill 卡尔文-克莱恩CK 金利来Goldlion 鳄鱼Lacoste Boss波士 万宝龙MontBlanc 都彭S.T.Dupont Lee)

ColorValues = %w(F44336 E91E63 9C27B0 673AB7 3F51B5 2196F3 03A9F4 00BCD4 009688 4CAF50 8BC34A CDDC39 FFEB3B FFC107 FF9800 FF5722 795548 795548 607D8B FFFFFF)

def fake_user(type='Customer', is_member=false)
  u = @store.users.create!(
    name: Faker::Name.name, 
    email: Faker::Internet.email, 
    password: 'password', 
    type: type, 
    password_confirmation: 'password', 
    phone: Faker::PhoneNumber.cell_phone,
    is_member: is_member, 
    balance: Faker::Number.number(4).to_i
  )
end

def fake_address(u)
  address1 = u.addresses.create!(
    country: Faker::Address.country, 
    province: Faker::Address.state, 
    details: Faker::Address.street_address
  )
end

def fake_order(u, address)
  order = u.orders.create!(
    number: Faker::Number.number(10),
    delivery_date: Faker::Time.forward(rand(7), :morning),
    fetch_date: Faker::Time.backward(rand(7), :evening), 
    delivery_manner: u.id.odd?, 
    address_id: address.id, 
    item_id: u.id%30+1,
    status: u.id%9, 
    store_id: u.store_id, 
  )
end

@store = Store.find_or_create_by! name: '包拯工作室小悦城店'

#create colors
ColorValues.each { |color| Color.create!(value: color, name: Faker::Commerce.color) }

# create 10 bags
BagBrand.each_with_index do |name, i|
  Bag.create!(
    brand: name, 
    style: Faker::Lorem.word, 
    color_id: i+1
  )
end

# create 10 Belts
BeltBrand.each_with_index do |name, i|
  Belt.create!(
    brand: name, 
    style: Faker::Lorem.word, 
    color_id: i+1
  )
end

# create 10 Shoes
ShoeBrand.each_with_index do |name, i|
  Shoe.create!(
    brand: name, 
    style: Faker::Lorem.word, 
    color_id: i+1
  )
end

10.times do |i|
  SoluTemplate.create!(
    header: Faker::Lorem.paragraph, 
    footer: Faker::Lorem.paragraph,
    before: i.odd? 
  )
end

# create 500 customers and orders
500.times do |i|
  u = fake_user('Customer', i.odd?)

  addresses = []
  addresses << fake_address(u)
  addresses << fake_address(u)

  fake_order(u, addresses[i%2])
  fake_order(u, addresses[i%2]) if i.odd?

  puts "Created user #{u.name}"
end

# # create a manager
# @manager = fake_user 'Manager'
# 
# # create a Admin
# @admin = fake_user 'Admin'
# 
# # create 10 FrontDesker 
# 10.times { fake_user 'FrontDesker' }
# 
# # create 10 Solutionist 
# 10.times { fake_user 'Solutionist' }
# 
# # create a Worker
# 10.times { fake_user 'Worker' }
# 
