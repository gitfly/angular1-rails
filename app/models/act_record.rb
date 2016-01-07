class ActRecord < ActiveRecord::Base
  has_many :orders
  has_many :activity_codes
  belongs_to :settlement
end
