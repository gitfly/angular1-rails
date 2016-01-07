class ActivityCode < ActiveRecord::Base
  belongs_to :activity
  belongs_to :customer
  belongs_to :order, counter_cache: :groupon_codes_count
  belongs_to :settlement
end
