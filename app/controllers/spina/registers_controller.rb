module Spina
  class RegistersController < Spina::ApplicationController
    helper_method :sort_column, :sort_direction

    layout "layouts/default/application"

    def index
      if params[:phase].present?
        @registers = Spina::Register.by_phase(params[:phase]).order("#{sort_column} #{sort_direction}")
      else
        @registers = Spina::Register.order("#{sort_column} #{sort_direction}")
      end

      @page = Spina::Page.find_by(name: 'registerspage')
      @current_phases = Spina::Register::CURRENT_PHASES
    end

    def show
      @register = Spina::Register.find_by_slug!(params[:id])
    end

    private

    def sortable_columns
      ["name", "register_phase", "authority"]
    end

    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : "name"
    end

    def sort_direction
      ["asc", "desc"].include?(params[:direction]) ? params[:direction] : "asc"
    end
  end
end
