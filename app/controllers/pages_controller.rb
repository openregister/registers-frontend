# frozen_string_literal: true

class PagesController < ApplicationController
  layout 'layouts/application'

  before_action :get_ready_to_use_registers, only: %i[avaliable_registers home]

  def home
    @registers = Register.all
  end

  def roadmap; end

  def services_using_registers; end

  def avaliable_registers; end

  def combining_registers; end

  def case_study; end

private

  def get_ready_to_use_registers
    @beta_registers = Register.where(register_phase: 'Beta').select(&:records?)
  end
end
