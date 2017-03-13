require 'deskpro/deskpro_feedback_service'
require 'json'

class SendFeedbackController < ApplicationController

  layout "layouts/default/application"

  def index
    render locals: { current_account: ::Spina::Account.first }
  end

  def createTicket
    @deskproService = DeskproFeedbackService.new(params[:email], generate_title, params[:message])
    @response = @deskproService.send_feedback

    if @response.status.code != 201
      logger.debug("Feedback ticket creation failed with status: #{@response.status} and content: #{@response.body}")
    end

    render :json => JSON.parse(@response.body), :status => @response.status.code
  end

  def generate_title
    @title = 'Feedback has been submitted'

    unless params[:registerName].nil? || params[:registerName].empty?
      @title << ' for ' + params[:registerName]
    end

    unless params[:name].nil? || params[:name].empty?
      @title << ' from ' + params[:name]
    end
  end

end
