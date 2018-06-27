class RecordsController < ApplicationController
  def show
    @register = Register.find_by_slug!(params[:register_id])
    @record = @register.records.record(params[:id])
  end
end
