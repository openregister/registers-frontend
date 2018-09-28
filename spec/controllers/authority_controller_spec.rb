require 'rails_helper'

RSpec.describe AuthorityController, type: :controller do
  describe "Categories index page" do
    it "returns a 301 redirect" do
      get :index
      expect(response).to have_http_status(301)
    end
    it "redirects to the registers collection page with Organisation selected" do
      get :index
      expect(response.location).to end_with registers_path(show_by: "organisation")
    end
  end
end
