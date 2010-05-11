require 'spec_helper'

describe "assets/edit.html.erb" do
  before(:each) do
    assign(:asset, @asset = stub_model(Asset,
      :new_record? => false,
      :name => "MyString"
    ))
  end

  it "renders the edit asset form" do
    render

    response.should have_selector("form", :action => asset_path(@asset), :method => "post") do |form|
      form.should have_selector("input#asset_name", :name => "asset[name]")
    end
  end
end
