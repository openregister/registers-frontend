class ThemesController < ApplicationController
  def index
    # redirect to homepage plz
  end

  def show
    @registers_collections = Theme.themes
    @collection = Theme.collection(params[:slug])
  end
end
