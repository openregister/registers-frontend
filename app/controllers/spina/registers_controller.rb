module Spina
  class RegistersController < Spina::ApplicationController
    before_action :set_register, only: [:show]

    helper_method :sort_column, :sort_direction

    layout "layouts/default/application"

    def index
      @registers = Spina::Register.order("#{sort_column} #{sort_direction}")
      @page = Spina::Page.find_by(name: 'registerspage')
    end

    def show
      @current_phases = Spina::Register::CURRENT_PHASES
    end

    private

    def sortable_columns
      ["name", "current_phase", "owner"]
    end

    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : "name"
    end

    def sort_direction
      ["asc", "desc"].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def set_register
      @register = Spina::Register.find_by_slug(params[:id])
    end
  end
end
