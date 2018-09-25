class CategoryController < ApplicationController
  def index
    redirect_to registers_path, status: 301
  end

  def show
    @collection = Category.collection(params[:slug])
  end
end
