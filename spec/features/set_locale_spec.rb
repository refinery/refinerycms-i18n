# encoding: utf-8
require "spec_helper"

describe "set_locale parameter", :type => :feature do
  refinery_login

  it "changes language used in backend" do
    visit refinery.admin_pages_path

    expect(page).to have_content("Switch to your website")

    visit refinery.admin_pages_path(:set_locale => :cs)

    expect(page).to have_content("Přepnout na web")
  end
end
