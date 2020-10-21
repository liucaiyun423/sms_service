class TextMessageLogsController < ApplicationController
  def create
    TextMessageLog.create(text_message_log_params)
    status = params['status'] == 'invalid' ? 'invalid_number' : params['status']
    TextMessage.find_by(message_id: params['message_id'])&.update(status: status)
    render status: :no_content
  end

  private

  def text_message_log_params
    params.require(:text_message_log).permit(:message_id, :status)
  end
end
