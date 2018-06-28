class ErrorsController < ApplicationController
  def not_found
    respond_to do |format|
      format.html { render status: 404 }
      format.any { head :not_found }
    end
  end

  def internal_server_error
    respond_to do |format|
      format.html { render status: 500 }
      format.any { head :internal_server_error }
    end
  end
end
