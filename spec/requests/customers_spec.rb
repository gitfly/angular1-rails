require 'rails_helper'

describe API::V1::Customers do

  describe "GET /api/v1/customers/source" do
    before(:each) do
      c1 = create(:customer, source: "大众点评", email: "c1@baozheng.cc")
      c2 = create(:customer, source: "大众点评", email: "c2@baozheng.cc")
      c3 = create(:customer, source: "大众", email: "c3@baozheng.cc")
      c4 = create(:customer, source: "微信", email: "c4@baozheng.cc")
    end

		it "return all customer source when query with an empty source"do
      api_get "customers/source", source: ""
      expect(json_body).to eq(["大众", "大众点评", "微信"])
    end

    it "return matched customer source queried by keyword source"do
      api_get "customers/source", source: "大"
      expect(json_body).to eq(["大众", "大众点评"])
    end

    it "return blank array when query source unmatched"do
      api_get "customers/source", source: "hello"
      expect(json_body).to eq([])
    end
  end

  describe "GET /api/v1/customers/sub_source" do
    before(:each) do
      c1 = create(:customer, source: "大众点评", email: "c1@baozheng.cc", sub_source: "sub_source1")
      c2 = create(:customer, source: "大众点评", email: "c2@baozheng.cc", sub_source: "sub_source2")
      c3 = create(:customer, source: "大众点评", email: "c3@baozheng.cc", sub_source: "sub_source3")
      c4 = create(:customer, source: "微信", email: "c4@baozheng.cc", sub_source: "sub_source4")
    end

    it "return matched customer sub source queried by keyword source and sub_source"do
      api_get "customers/sub_source", source: "大", sub_source: "sub_source"
      expect(json_body).to eq(["sub_source1", "sub_source2", "sub_source3"])
    end

		it "return all customer sub_source of a source when query with an empty sub_source"do
      api_get "customers/sub_source", source: "大", sub_source: ""
      expect(json_body).to eq(["sub_source1", "sub_source2", "sub_source3"])
    end

		it "return all customer sub_source when query with an empty sub_source"do
      api_get "customers/sub_source", source: "", sub_source: ""
      expect(json_body).to eq(["sub_source1", "sub_source2", "sub_source3", "sub_source4"])
    end

    it "return blank array when query source unmatched"do
      api_get "customers/sub_source", source: "hello", sub_source: "sub_source"
      expect(json_body).to eq([])
    end

    it "return blank array when query sub source unmatched"do
      api_get "customers/sub_source", source: "大", sub_source: 'hello'
      expect(json_body).to eq([])
    end
  end

  describe "GET /api/v1/customers/exists", focus: true do
    before(:each) do
      @customer = create(:customer, phone: 18601257148)
    end

    it "returns true when customer queried with phone existed"do
      api_get "customers/exists", attr: 'phone', value: 18601257148
      expect(response.body).to eq('true')
    end

    it "returns false when customer queried with phone not existed"do
      api_get "customers/exists", attr: 'phone', value: 11111111111
      expect(response.body).to eq('false')
    end
  end

  # describe "GET /api/v1/customers/:id/unfinished_orders" do
  #   it "" do
  #     api_get "customers/1/unfinished_orders"
  #   end
  # end

  # describe "PUT /api/v1/orders/:id/goto_next_status" do
  #   it "should return an the next status of order" do
  #     put "/api/v1/orders/1/goto_next_status"
  #     puts response.body
  #     # expect_json(status.as_json)
  #     # expect(response.status).to eq(200)
  #   end
  # end

end
