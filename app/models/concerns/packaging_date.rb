module PackagingDate
  extend ActiveSupport::Concern

  module ClassMethods
    def parse_param_date(params, past_days=0)
      if params[:from].blank?
        from = Time.zone.now.beginning_of_day - past_days.days
      else 
        from = Time.parse(params[:from]).beginning_of_day
      end

      if params[:from].blank?
        to = Time.zone.now 
      else
        to = Time.parse(params[:to]).end_of_day   
      end
      return [from, to]
    end
  end

end