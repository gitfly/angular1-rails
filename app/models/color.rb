class Color < ActiveRecord::Base
  has_many :items

  def self.colors
    {}.tap do |hash|
      all.each do |c|
        hash.merge!("#{c.name}-#{c.value}": c.id)
      end
    end
  end
end
