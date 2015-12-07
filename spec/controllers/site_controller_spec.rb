require 'rails_helper'

RSpec.describe SiteController, type: :controller do

  describe 'GET /' do
    it 'render the home page' do
      get :home
      expect(response).to render_template(:home)
      expect(response).to have_http_status(200)
    end
  end

end
