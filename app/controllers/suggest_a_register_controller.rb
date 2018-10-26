# frozen_string_literal: true

class SuggestARegisterController < ApplicationController
  invisible_captcha only: :create_feedback, honeypot: :spam

  def index
    @government_organisations = Register.find_by(slug: 'local-authority-eng')
                                        .records
                                        .where(entry_type: 'user')
                                        .current
  end

  def check
    if params['suggest_a_register']['gov_what_part_of_government'].present?
      redirect_to suggest_a_register_complete_path
    else
      flash[:summary_title] = 'There is a problem'
      flash[:summary_message] = 'A government department needs to be selected'
      flash[:error_message] = 'Select a government department'
      redirect_to suggest_a_register_path
    end
  end

  def complete; end
end
