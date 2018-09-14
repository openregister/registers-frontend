class AuthorityController < ApplicationController
  def index
    redirect_to registers_path(showby: "organisation"), status: 301
  end

  def show
    @authority_collection = Authority.collection(params[:slug])
  end
end
