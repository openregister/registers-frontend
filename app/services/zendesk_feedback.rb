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
        # Passing Anonymous down to ZenDesk as name is not always required in our forms
        name: params[:name].present? ? params[:name] : 'Anonymous',
        email: params[:email] ? params[:email] : 'Anonymous'
      }
    }

    response = @client.tickets.create!(ticket)

    { success: true, ticket_id: response.id }
  rescue ZendeskAPI::Error::ClientError => e
    Rails.logger.error("Feedback ticket creation failed with status: #{e.response.status} and content: #{e.response.body}")

    { success: false, message: response.body }
  end
end
