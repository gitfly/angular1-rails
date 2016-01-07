module SessionHelper
  def setup_access_token
    @admin = create(:admin)
    @access_token = create(:access_token, resource_owner_id: @admin.id)
  end

  def access_token_header
    setup_access_token
    { "Authorization":  "Bearer #{@access_token.token}"}
  end
end
