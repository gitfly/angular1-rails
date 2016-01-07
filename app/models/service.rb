class Service < ActiveRecord::Base
  acts_as_paranoid

  NameSeparator = "， "

  def self.types
    {}.tap do |hash|
      all.map do |s|
        hash.merge!("#{s.name} - #{s.price}元": s.id)
      end
    end
  end

end
