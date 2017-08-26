require "spec_helper"

module Refinery
  module Admin
    describe ResourcesController, type: :controller do
      before do
        Globalize.locale = :en
        @resource = FactoryGirl.create(:resource, :resource_title => "My resource in English")

        # Add a translation
        Globalize.locale = :es
        @resource.resource_title = 'Mi recurso en español'
        @resource.save
      end

      it 'reset Globalize as expected' do
        get :index
        expect(Globalize.locale).to eql(:en)
        expect(::I18n.locale).to eql(:en)
        expect(assigns(:resources).first.resource_title).to eql('My resource in English')

        # Switch globalized content to ES
        get :index, params: { switch_locale: :es }
        expect(Globalize.locale).to eql(:es)
        expect(::I18n.locale).to eql(:en)
        expect(assigns(:resources).first.resource_title).to eql('Mi recurso en español')

        # Should return to default locale for globalized content on next request
        get :index
        expect(Globalize.locale).to eql(:en)
        expect(::I18n.locale).to eql(:en)
        expect(assigns(:resources).first.resource_title).to eql('My resource in English')
      end
    end
  end
end
