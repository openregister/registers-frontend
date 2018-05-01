require 'zendesk_api'

class ZendeskFeedback
  def initialize
    @client = ZendeskAPI::Client.new do |config|
      config.url = Rails.configuration.x.zendesk.url
      config.username = Rails.configuration.x.zendesk.username
      config.token = Rails.configuration.x.zendesk.token
    end
  end

  def send_feedback(params)
    ticket = {
      subject: params[:subject],
      comment: {
        body: params[:message]
      },
      requester: {
        name: params[:name],
        email: params[:email]
      }
    }

    response = @client.tickets.create!(ticket)

    { success: true, ticket_id: response.id }
  rescue ZendeskAPI::Error::ClientError => e
    Rails.logger.error("Feedback ticket creation failed with status: #{e.response.status} and content: #{e.response.body}")

    { success: false, message: response.body }
  end
end
