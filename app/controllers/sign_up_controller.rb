require 'digest'

class SignUpController < ApplicationController
  include FormHelpers

  before_action :set_register, only: [:index, :create]

  def index
    @sign_up_user = SignUpUser.new
    @custom_dimension = params[:from].tr('-', ' ') + ' - ' + params[:method] if params[:from].present? && params[:method].present?
  end

  def create
    mailchimp_client = Gibbon::Request.new(api_key: Rails.configuration.x.mailchimp.api_key, symbolize_keys: true)

    list_id = Rails.configuration.x.mailchimp.list_id
    email_address = permitted_params['email']

    begin
      merge_fields = {
        REGISTER: @register&.slug
      }.compact

      response = mailchimp_client.lists(list_id)
        .members(Digest::MD5.hexdigest(email_address))
        .upsert(
          body: { email_address: email_address, status: 'pending', merge_fields: merge_fields }
        )

      if response.body[:status] == "pending"
        redirect_to sign_up_thank_you_path and return
      else
        flash.now[:alert] = 'Something went wrong while adding you to the list'
        Rails.logger.error "Unable to add user to mailing list: status was #{response.body[:status]}"
      end

    rescue Gibbon::MailChimpError => e
      flash.now[:alert] = case e.body[:detail]
        when /Please provide a valid email address/
          e.body[:detail]
        else
          Rails.logger.error "Error adding user to mailing list: #{e.body[:status]} #{e.body[:detail]}"

          'Something went wrong while adding you to the list'
        end
    end

    @sign_up_user = SignUpUser.new(email: email_address)
    render :index
  end

  def thank_you
    @custom_dimension = params[:from].tr('-', ' ') + ' - ' + params[:method] if params[:from].present? && params[:method].present?
  end

private

  def permitted_params
    params.require(:sign_up_user).permit(:email)
  end

  def set_register
    @register = Register.find_by(slug: params[:from])
  end
end
