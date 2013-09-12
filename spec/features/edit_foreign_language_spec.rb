# encoding: utf-8
require "spec_helper"

describe "edit_foreign_language" do
  before(:each) do
    Refinery::I18n.configure do |config|
      config.default_frontend_locale = :"pt-BR"
    end
  end

  refinery_login_with :refinery_user

  it "is able to edit a page in a non-standard language", :js => true do
    # I've tried to create the page programmatically with the following statement,
    # however it didn't reproduce the issue
    #::Refinery::Page.create(:title => "Some title")

    visit refinery.admin_pages_path

    page.should have_content("Switch to your website")

    within "#actions" do
      click_link "Add new page"
    end

    page.should have_content("Title")

    fill_in("Title", :with => "Some title")

    click_button "Save"

    page.should have_content("successfully added")

    within "#page_1" do
      find('a[href*="/edit"]').click
    end

    page.should have_content("Title")
  end
end
