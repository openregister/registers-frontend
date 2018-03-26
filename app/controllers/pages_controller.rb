# frozen_string_literal: true

class PagesController < ApplicationController
  layout 'layouts/application'

  def home
    @registers = Register.available.all

    @ready_registers = Register.available.where(register_phase: 'Beta')
    @upcoming_registers = Register.available.where.not(register_phase: 'Beta')
  end

  def roadmap; end

  def services_using_registers; end

  def combining_registers; end

  def case_study; end
end
