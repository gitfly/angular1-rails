class QualityTesting < ActiveRecord::Base
  belongs_to :technology
  belongs_to :order

  has_one :photo, as: :photoable

  after_save :set_repeated, :unless => :qualified

  private
    def set_repeated
      self.technology.update_attributes(repeated: true)
    end
end
