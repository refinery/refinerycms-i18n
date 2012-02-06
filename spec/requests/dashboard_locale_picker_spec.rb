# encoding: utf-8
require "spec_helper"

describe "dashboard locale picker" do
  login_refinery_user

  it "changes language used in backend" do
    visit refinery.admin_dashboard_path

    page.should have_content("Switch to your website")

    within "#current_locale" do
      click_link "Change language"
    end
    within "#other_locales" do
      click_link "Latviski"
    end

    page.should have_content("Pārslēgties uz jūsu saitu")
    page.should have_no_content("Switch to your website")

    within "#current_locale" do
      click_link "Mainīt valodu"
    end
    within "#other_locales" do
      click_link "English"
    end

    page.should have_content("Switch to your website")
    page.should have_no_content("Pārslēgties uz jūsu saitu")
  end
end
