class SoluTemplate < ActiveRecord::Base
  has_many :photos, as: :photoable
  has_and_belongs_to_many :orders

  scope :before, -> { where(before: true) }
  scope :after, -> { where(before: false) }

  def self.rand_template(before=true)
    self.where(before: before)[rand(self.where(before: before).count)]
  end
end
