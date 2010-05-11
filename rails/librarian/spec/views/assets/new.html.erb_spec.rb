require 'spec_helper'

describe "assets/new.html.erb" do
  before(:each) do
    assign(:asset, stub_model(Asset,
      :new_record? => true,
      :name => "MyString"
    ))
  end

  it "renders new asset form" do
    render

    response.should have_selector("form", :action => assets_path, :method => "post") do |form|
      form.should have_selector("input#asset_name", :name => "asset[name]")
    end
  end
end
