require 'rails_helper'

describe API::V1::Orders do

  describe "GET /api/v1/orders/:id" do
    it "" do
      api_get "orders/1"
      binding.pry
    end
  end
    

  describe "PUT /api/v1/orders/:id/goto_next_status" do
    it "should return an the next status of order" do
      put "/api/v1/orders/1/goto_next_status"
      puts response.body
      # expect_json(status.as_json)
      # expect(response.status).to eq(200)
    end
  end

end
