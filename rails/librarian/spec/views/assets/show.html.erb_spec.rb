require 'spec_helper'

describe "assets/show.html.erb" do
  before(:each) do
    assign(:asset, @asset = stub_model(Asset,
      :name => "MyString"
    ))
  end

  it "renders attributes in <p>" do
    render
    response.should contain("MyString")
  end
end
