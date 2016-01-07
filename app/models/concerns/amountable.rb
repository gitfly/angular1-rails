module Amountable
  extend ActiveSupport::Concern

  class_methods do
    def amountable(*args)
      args.each do |name|
        if name.is_a?(Hash)
          name.each do |k, v|
            define_amount_method(k, v)
          end
        else
          define_amount_method(name)
        end
      end
    end

    def define_amount_method(k, v=k)
      define_method v do 
        read_attribute(k).to_f/100.0
      end

      define_method "#{v}=" do |val|
        write_attribute(k, (val.to_f*100).to_i)
      end
    end
  end
end
