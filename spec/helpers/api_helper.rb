module ApiHelper
  def api_get(path, params={}, headers={})
    headers.merge!(access_token_header)
    get format_path(path), params, headers
  end

  def api_put(path, params={}, headers={})
    headers.merge!(access_token_header)
    put format_path(path), params, headers
  end

  def api_post(path, params={}, headers={})
    headers.merge!(access_token_header)
    post format_path(path), params, headers
  end

  def format_path(path)
    "/api/v1/#{path}"
  end
end
