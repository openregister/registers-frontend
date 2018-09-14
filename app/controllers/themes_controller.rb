class ThemesController < ApplicationController
  def index
    redirect_to registers_path, status: 301
  end

  def show
    @collection = Theme.collection(params[:slug])
  end
end
