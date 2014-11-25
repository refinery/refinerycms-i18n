# encoding: utf-8
require "spec_helper"

describe "set_locale parameter" do
  refinery_login_with :refinery_user

  it "changes language used in backend" do
    visit refinery.admin_pages_path

    page.should have_content("Switch to your website")

    visit refinery.admin_pages_path(:set_locale => :cs)

    page.should have_content("Přepnout na web")
  end
end
