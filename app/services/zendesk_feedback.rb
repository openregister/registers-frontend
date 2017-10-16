require 'zendesk_api'

class ZendeskFeedback
  def initialize
    @credentials = CF::App::Credentials.find_by_service_name('registers-product-site-environment-variables')

    @client = ZendeskAPI::Client.new do |config|
      config.url = @credentials['ZENDESK_URL']
      config.username = @credentials['ZENDESK_USERNAME']
      config.token = @credentials['ZENDESK_TOKEN']
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
    logger.debug("Feedback ticket creation failed with status: #{e.response.status} and content: #{e.response.body}")

    { success: false, message: response.body }
  end
end