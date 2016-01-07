class PhotoSymptom < ActiveRecord::Base
  belongs_to :photo
  belongs_to :category

  delegate :order, :to => :photo, :allow_nil => true

  serialize :symptoms, Array
  serialize :category_ids, Array

  def symptom_list
    symptoms.try(:split, ',') || []
  end

  def options
    c = Category.where(id: category_ids.last).first
    c.try(:children) || []
  end

end
