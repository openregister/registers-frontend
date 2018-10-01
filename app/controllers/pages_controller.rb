# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @registers = Register.available.all

    @registers_available = Register.available_count
    @organisation_count = Register.organisation_count

    @registers_collection = Category.with_a_register__homepage
  end

  def services_using_registers; end

  def combining_registers; end

  def case_study; end

  def privacy_notice; end

  def cookies; end

  def data_format_changes; end

  def about; end
end
