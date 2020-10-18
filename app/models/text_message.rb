class TextMessage < ApplicationRecord
  MAXIMUM_LEN = 160
  enum status: %i[queued started requested request_failed delivered failed invalid_number]

  validates :to_number, phone: true
  validates :message, length: { maximum: MAXIMUM_LEN }, allow_blank: false
  validates :status, inclusion: { in: statuses }

  before_validation :add_status, on: :create

  private

  def add_status
    self.status = :queued
  end
end
