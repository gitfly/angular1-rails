require 'rails_helper'

RSpec.describe "appointments/index", type: :view do
  before(:each) do
    assign(:appointments, [
      Appointment.create!(
        :customer_id => 1
      ),
      Appointment.create!(
        :customer_id => 1
      )
    ])
  end

  it "renders a list of appointments" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
