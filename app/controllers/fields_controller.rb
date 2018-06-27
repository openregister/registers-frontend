class FieldsController < ApplicationController
  def show
    @register = Register.find_by_slug!(params[:register_id])

    @field = Record.where(register_id: @register.id, key: "field:#{params[:id]}").first
  end
end
