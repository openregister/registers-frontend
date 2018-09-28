require 'rails_helper'

RSpec.describe CategoryController, type: :controller do
  describe "Category index page" do
    it "returns a 301 redirect" do
      get :index
      expect(response).to have_http_status(301)
    end
    it "redirects to the registers collection page" do
      get :index
      expect(response.location).to end_with registers_path
    end
  end
end
