module Spina
  class RegistersController < Spina::ApplicationController
    helper_method :sort_column, :sort_direction

    layout "layouts/default/application"

    def index
      @search = Spina::Register.ransack(params[:q])

      if params[:phase].present?
        @registers = @search.result.by_phase(params[:phase]).by_name
      else
        @registers = @search.result.sort_by_phase_name_asc.by_name
      end

      @page = Spina::Page.find_by(name: 'registerspage')
      @current_phases = Spina::Register::CURRENT_PHASES
    end

    def show
      @register = Spina::Register.find_by_slug!(params[:id])
    end
  end
end
