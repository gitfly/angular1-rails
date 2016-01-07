class DescTag < ActiveRecord::Base
  belongs_to :photo_desc

  def names
    read_attribute(:names).try(:split, ',')
  end

  def names=(array)
    write_attribute(:names, array.join(','))
  end

  def category_ids
    read_attribute(:category_ids).try(:split, ',')
  end

  def category_ids=(array)
    write_attribute(:category_ids, array.join(','))
  end
end
