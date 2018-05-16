require "spec_helper"

module Refinery
  describe PagesController, type: :controller do
    before do
      FactoryBot.create(:page, title: 'test')
    end

    context 'when locale is unsupported' do
      subject { get :show, params: { path: 'test', locale: 'en%20217' } }

      it 'redirects to the location with the default frontend locale' do
        expect(subject).to redirect_to ('/test')
      end

      it 'flashes a notice message' do
        expect(subject.request.flash[:notice]).to eq("The locale 'en%20217' is not supported.")
      end
    end
  end
end