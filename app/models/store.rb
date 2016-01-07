class Store < ActiveRecord::Base
  acts_as_paranoid

  has_many :users
  has_many :manager
  has_many :customers
  has_many :front_deskers
  has_many :orders

  has_many :addresses, as: :addressable
end
