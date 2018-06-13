class SitemapsController < ApplicationController
  def show
    @registers = Register.where(register_phase: %w[Alpha Beta]).has_records
  end
end
