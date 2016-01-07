module API
  module ErrorFormatter
    def self.call message, backtrace, options, env
      { :response_type => 'error', :response => message }.to_json
    end
  end
end


# You can override error formatter for particular api version. Let’s customize errors for API::v1::Root:
#
# #lib/api/v1/error_formatter.rb
# module API
#   module V1
#     module ErrorFormatter
#       def self.call message, backtrace, options, env
#         { :response_type => 'error', :response => message }.to_json
#       end
#     end
#   end
# end
# 
# # lib/api/v1/root.rb
# module API
#   module V1
#     class Root < Grape::API
#       #...
#       error_formatter :json, API::V1::ErrorFormatter
#       #...
#     end
#   end
# end
