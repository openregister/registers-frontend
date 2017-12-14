# frozen_string_literal: true
class PagesController < ApplicationController
  layout 'layouts/application'

  before_action :get_ready_to_use_registers, only: [:home, :avaliable_registers]

  def home
  end

  def roadmap
  end

  def services_using_registers
  end

  def avaliable_registers
  end

  def combining_registers
  end

  def case_study
  end

  private

  def get_ready_to_use_registers
    register_data = @@registers_client.get_register('register', 'beta')
    @beta_registers = register_data.get_records
  end
end
