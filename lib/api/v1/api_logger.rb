module API::V1
  class ApiLogger < Grape::Middleware::Base
    def before
      ap JSON.parse(@env["RAW_POST_DATA"]||{}.to_s)
      ap @env["ORIGINAL_FULLPATH"]
      ap @env['QUERY_STRING']
    end
    def after
      puts '-'*100
      puts '-'*100
      begin
        b = @app_response.last.body.first.length
        body = JSON.parse(b)
        ap "Status: #{@app_response.first}"
        ap body unless b > 2000
      rescue Exception => e
        puts e.message
      end
      puts '-'*100
      puts '-'*100
    end
  end
end
