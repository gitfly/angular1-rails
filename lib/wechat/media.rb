module Wechat
  class Media < Base

    def self.find(id)
      post_with_body "/cgi-bin/material/get_material", {media_id: id}
    end

    def self.list(params={type: 'news', count: 10, offset: 1})
      params.merge!(default_params)
      post_with_body "/cgi-bin/material/batchget_material", params
    end

    # POST https://api.weixin.qq.com/cgi-bin/material/add_material?access_token=ACCESS_TOKEN
    def self.create_image(file_path)
      rest_post "/cgi-bin/material/add_material", default_params.merge(
        type: 'image',
        media: File.new(file_path)
      )
    end

    # "title": TITLE, 
    #   "thumb_media_id": THUMB_MEDIA_ID, 
    #   "author": AUTHOR, 
    #   "digest": DIGEST, 
    #   "show_cover_pic": SHOW_COVER_PIC(0 / 1), 
    #   "content": CONTENT, 
    #   "content_source_url": CONTENT_SOURCE_URL

    # POST https://api.weixin.qq.com/cgi-bin/material/add_news?access_token=ACCESS_TOKEN
    def self.create_news(news = [])
      defaults = {show_cover_pic: 1}
      news.blank? and return {}
      news.map! { |new| defaults.merge(new) }
      post_with_body("/cgi-bin/material/add_news", articles: news)
    end

  end
end
