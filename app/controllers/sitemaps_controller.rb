class SitemapsController < ApplicationController
  def show
    @registers = Register.where(register_phase: %w[Alpha Beta]).has_records.sort_by_phase_name_asc.by_name
  end
end
