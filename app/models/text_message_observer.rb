class TextMessageObserver < ActiveRecord::Observer
  def after_save(message)
    TextMessageDeliverJob.perform_later message.id if message.queued?
  end
end