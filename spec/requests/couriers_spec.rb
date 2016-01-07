require 'rails_helper'

describe API::V1::Couriers do

  describe "GET /api/v1/couriers" do
		it "return all couriers with desc order"do
      create :courier, email: "c1@baozheng.cc", name: "c1"
      create :courier, email: "c2@baozheng.cc", name: "c2"
      create :courier, email: "c3@baozheng.cc", name: "c3"

      api_get "couriers"

      expect(json_body.length).to eq(3)
      expect(json_body[0][:name]).to eq('c3')
      expect(json_body[2][:name]).to eq('c1')
    end

    it "return all blank array when no couriers"do
      api_get "couriers"
      expect(json_body).to eq([])
    end
  end

end
