require 'rails_helper'

describe API::V1::Root do

  describe "POST /oauth/token" do
    # let(:default_headers) { {'x-auth-token' => 'Header value'} }

    it "does get access token" do
      @ios = create(:app)
      @admin = create(:customer)

      post "/oauth/token", {
        grant_type: :password, 
        username: @admin.email, 
        password: @admin.password,
        client_id: @ios.uid,
        client_secret: @ios.secret
      }

      expect_json_types({access_token: :string, token_type: :string})
      expect(json_body[:token_type]).to be == 'bearer'
      expect(json_body[:expires_in]).to be == 86400
      expect(json_body[:access_token].length).to be == 64

      # get "/api/v1/users/me", {}, { "Authorization":  "Bearer #{@ios.access_tokens.first.token}"}
      # expect(response.body)
    end
  end
end
