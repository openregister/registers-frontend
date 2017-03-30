require 'http'
require 'uri'

class DeskproFeedback

  attr_reader :params, :name, :email, :message, :register_name

  @@url = ENV["DESKPRO_API_BASE_URL"]
  @@key = ENV["DESKPRO_API_KEY"]

  def initialize(params)
    @@person_name = params[:name]
    @@person_email = params[:email]
    @@register = params[:register_name]
    @@message = params[:message]
  end

  def send_feedback
    HTTP.headers('X-Deskpro-Api-Key' => @@key).post(post_ticket_url)
  end

  # Subject, message and person identifier required https://manuals.deskpro.com/html/developer-apps/api/api-tickets.html
  def post_ticket_url
    URI.encode(@@url + '/tickets' + '?subject=Feedback&message=' + @@message + '&person_email=' + @@person_email + '&person_name=' + @@person_name)
  end

end
