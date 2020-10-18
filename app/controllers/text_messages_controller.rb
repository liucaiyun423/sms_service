class TextMessagesController < ApplicationController
  def create
    text_message = TextMessage.create!(text_message_params)
    render status: :accepted, json: text_message
  rescue ActionController::ParameterMissing, ActiveRecord::RecordInvalid => e
    render status: :unprocessable_entity, json: e.message
  end

  private

  def text_message_params
    params.require(:text_message).permit(:to_number, :message)
  end

end
