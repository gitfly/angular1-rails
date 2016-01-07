class WechatsController < ApplicationController
  respond_to :xml

  before_filter :set_weixin_account, except: [:verify_token]

  skip_before_action :authenticate_user!

  def verify_token
    render json: params[:echostr]
  end

  def receive_msg
    render xml: Wechat::Responder.new(params[:xml], @weixin).response
  end

  private

  def set_weixin_account
    @weixin = WeixinAccount.where(
      openid: params[:xml]["FromUserName"]
    ).first_or_create!
  end

end
