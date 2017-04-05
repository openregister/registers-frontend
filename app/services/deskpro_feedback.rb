require 'http'
require 'uri'

class DeskproFeedback

  attr_reader :params, :name, :email, :message, :register_name, :subject

  @@url = ENV['DESKPRO_API_BASE_URL']
  @@key = ENV['DESKPRO_API_KEY']

  def initialize(params)
    @@person_name = params[:name]
    @@person_email = params[:email]
    if params[:register_name].present?
      @@message = 'Register name: ' + params[:register_name] + '. Description: ' + params[:message]
    else
      @@message = params[:message]
    end
    @@subject = params[:subject]
  end

  def send_feedback
    HTTP.headers('X-Deskpro-Api-Key' => @@key).post(post_ticket_url)
  end

  # Subject, message and person identifier required https://manuals.deskpro.com/html/developer-apps/api/api-tickets.html
  def post_ticket_url
    URI.encode(@@url + '/tickets?subject=' + @@subject + '&message=' + @@message + '&person_email=' + @@person_email + '&person_name=' + @@person_name)
  end

end
