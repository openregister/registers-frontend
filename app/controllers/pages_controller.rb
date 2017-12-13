# frozen_string_literal: true
class PagesController < ApplicationController
  layout 'layouts/application'

  def home
    @page_title = 'Home'

    register_data = @@registers_client.get_register('register', 'beta')
    @beta_registers = register_data.get_records
  end

  def cookies
    @page_title = 'Cookies'
  end
end
