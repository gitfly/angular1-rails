module Wechat::Wechatable
  extend ActiveSupport::Concern

  class_methods do

    def access_token
      ::WechatToken.get_token.access_token
    end

    def default_params
      params = { access_token: access_token }
    end

    def generate_url(path)
      "#{Settings.wechat.host}/#{path.gsub(/^\//, '')}"
    end

    def request(path, options={})
      request = Typhoeus::Request.new(generate_url(path), options)
      response = request.run
      mdata = response.body.match(/({\".*})/)
      if mdata
        JSON.parse(mdata.captures.first).tap do |res|
          raise(Wechat::ApiError.new(request), res['errmsg']) unless res['errcode'].blank?
        end
      else
        raise(Wechat::ApiError.new(request), "Error: Unexpected response body")
      end
    end

    def request_with_token(path, options={})
      request "#{path}?access_token=#{access_token}", options
    end

    def get(path, params={}, header={})
      params.merge!(access_token: access_token) unless params.delete(:without_token)
      request(path, {
        method: :get,
        params: params, 
        header: header 
      })
    end

    def post(path, params={}, header={})
      params.merge!(access_token: access_token) unless params.delete(:without_token)
      request(path, {
        method: :post,
        params: params, 
        header: header 
      })
    end

    def post_with_params(path, params={}, header={})
      request_with_token(path, {
        method: :post,
        params: params, 
        header: header 
      })
    end

    def post_with_body(path, body={}, header={})
      request_with_token(path, {
        method: :post,
        header: header, 
        body: body.to_json
      })
    end

    %w(get post patch put delete head options).each do |name|
      define_method "rest_#{name}" do |*args|
        args[0] = "#{Settings.wechat.host}#{args.first}"
        RestClient.send name, *args do |response, request, result|
          JSON.parse(response.body).tap do |res|
            data = {response: response, request: request, result: result}
            res['errcode'].present? and raise(Wechat::ApiError.new(data), res['errmsg'])
          end
        end
      end
    end

  end
end




















