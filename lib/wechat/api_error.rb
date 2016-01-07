class Wechat::ApiError < StandardError
  def initialize(request=nil)
    @request = request
  end
end
