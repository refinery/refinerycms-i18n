# encoding: utf-8
require "spec_helper"

describe "#home page" do

  before(:all) do
    # I expect this is required for testing paths like /de/...
    # calling it fails with "uninitialized constant RefinerySetting"
    #RefinerySetting.find_or_set(:i18n_translation_frontend_locales, [:en, :de])

    # So that we can use Refinery.
    Factory(:refinery_user)
    # Create some pages for these specs
    Factory(:page, :title => 'Home', :link_url => '/')
    Factory(:page, :title => 'About')    
  end
  
  it "considers '/' the home page" do
    visit "/"
    within('head') do
      page.should have_content("home.css")
    end
  end
  
  it "considers '/de' the home page, too"
  it "does not consider /about the home page"
  it "does not consider /de/about the home page"
  
end
