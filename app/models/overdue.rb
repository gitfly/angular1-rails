class Overdue < ActiveRecord::Base
  belongs_to :order

  def over_days	
  	if expected_date && original_date
  		(expected_date - original_date).to_i
  	end
  		
  end

end
