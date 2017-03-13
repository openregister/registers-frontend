require 'http'
require 'uri'

class DeskproFeedbackService

  @@url = ENV["DESKPRO_API_BASE_URL"]
  @@key = ENV["DESKPRO_API_KEY"]

  def initialize(email, subject, message)
    @@person_email = email
    @subject = subject
    @message = message
  end

  def send_feedback
    HTTP.headers('X-Deskpro-Api-Key' => @@key).post(post_ticket_url)
  end

  # Subject, message and person identifier required https://manuals.deskpro.com/html/developer-apps/api/api-tickets.html
  def post_ticket_url
    URI.encode(@@url + '/tickets' + '?subject=' + @subject + '&message=' + @message + '&person_email=' + @@person_email)
  end

end

