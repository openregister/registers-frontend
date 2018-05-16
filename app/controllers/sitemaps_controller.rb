class SitemapsController < ApplicationController
  def show
    @registers = Register.sort_by_phase_name_asc.by_name
  end
end
