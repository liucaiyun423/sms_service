require 'rails_helper'

RSpec.describe 'text_messages' do
  let(:subject) do
    FactoryBot.build(:text_message)
  end

  context 'on create' do
    it 'save successfully' do
      expect(subject).to be_valid
    end

    it 'is invalid when country code is not included' do
      invalid = FactoryBot.build :text_message, to_number: '6177174802'
      expect(invalid).to be_invalid
    end

    it 'is invalid when SMS body is too long' do
      invalid = FactoryBot.build :text_message, message: 'a' * (TextMessage::MAXIMUM_LEN + 1)
      expect(invalid).to be_invalid
    end

  end
end