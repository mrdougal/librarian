require 'spec_helper'

describe "assets/index.html.erb" do
  before(:each) do
    assign(:assets, [
      stub_model(Asset,
        :name => "MyString"
      ),
      stub_model(Asset,
        :name => "MyString"
      )
    ])
  end

  it "renders a list of assets" do
    render
    response.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
  end
end
