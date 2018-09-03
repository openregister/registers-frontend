# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @registers = Register.available.all

    @registers_available = Register.available.where(register_phase: 'Beta')
    @organisation_count = @registers_available.distinct.count(:authority)
  end

  def services_using_registers; end

  def combining_registers; end

  def case_study; end

  def privacy_notice; end

  def cookies; end
end
