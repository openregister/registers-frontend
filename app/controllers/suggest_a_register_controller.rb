# frozen_string_literal: true

class SuggestARegisterController < ApplicationController
  include FormHelpers
  helper_method :government_orgs_local_authorities
  invisible_captcha only: :create_feedback, honeypot: :spam

  def index
    @government_organisations = government_orgs_local_authorities
  end

  def check
    if params['suggest_a_register']['gov_what_part_of_government'].present?
      redirect_to suggest_new_register_complete_path
    else
      flash[:error_message] = 'Enter a government or public sector organisation'
      redirect_to suggest_new_register_path
    end
  end

  def complete; end
end
