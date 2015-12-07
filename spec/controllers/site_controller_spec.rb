require 'rails_helper'

RSpec.describe SiteController, type: :controller do

  describe 'GET /' do
    it 'render the home template' do
      get :home
      expect(response).to render_template(:home)
    end

    it 'respond with a 200 status code' do
      get :home
      expect(response).to have_http_status(200)
    end
    
  end

end
