module Wechat
  class Responder
    def initialize(params, weixin=nil)
      raise "no FromUserName provided" if params['FromUserName'].blank?
      @params = params
      @content = params["Content"]
      @weixin = weixin || WeixinAccount.where(
        openid: params["FromUserName"]
      ).first
    end

    def hash_response
      event = @params['Event'].blank? ? '' : "#{@params['Event']}_"
      method = "respond_to_#{event}#{@params['MsgType']}"

      defaults.tap do |hash|
        if respond_to?(method)
          hash[:xml].merge!(send(method)) 
        else
          hash[:xml].merge!(Content: Settings.wechat.default_response_content)
        end
      end
    end

    def hash_to_xml(hash)
      hash.is_a?(Hash) or return hash
      "".tap do |str|
        hash.each do |k, v|
          case v
          when Hash
            str << "<#{k}>#{hash_to_xml(v)}</#{k}>"
          when Array
            str << v.map { |value| "<#{k}>#{hash_to_xml(value)}</#{k}>" }.join
          else
            str << "<#{k}><![CDATA[#{v}]]></#{k}>"
          end
        end
      end
    end

    def response
      hash_to_xml hash_response
    end

    # https://open.weixin.qq.com/connect/oauth2/authorize?
    # appid=wxc73af915e5f333c3&
    # redirect_uri=http%3A%2F%2Fbaozhengtest.somami.cn%2Fappointments%2Fwelcome&
    # response_type=code&
    # scope=snsapi_userinfo&
    # state=teststate#wechat_redirect

    # def appointment_url
    #   Settings.wechat.welcome_url
    #   # url = "http://#{Settings.host}/appointments/welcome?code=#{@weixin.code}"
    #   # 3.times do |i|
    #     # respose = RestClient.post(Settings.baidu.short_url, url: url)
    #     # respose.code == 200 and return JSON.parse(respose)['tinyurl']
    #   # end
    #   # url
    # end

    def respond_to_text
      {}.tap do |hash|
        case @content
        when '0'
          hash[:Content] = "点我👉 #{Settings.wechat.welcome_url} 马上预约下单 找大人拯救你的宝贝～ 亲自到店的小主不用预约就直接来吧！;[亲亲]"
        when /^[1-4]$/
          hash.merge!(
            MsgType: 'news', 
            ArticleCount: "1", 
            Articles: {
              item: [Settings.wechat.news.send("response#{@content}").to_hash]
            }
          )
        else
          hash[:Content] = Settings.wechat.default_response_content
        end
      end
    end

    def defaults
      { 
        xml: {
          CreateTime: Time.now.to_i,
          MsgType: @params['MsgType'],
          ToUserName: @params['FromUserName'],
          FromUserName: @params['ToUserName'],
        }
      }
    end
  end
end

