require 'rails_helper'

RSpec.describe TextMessagesController, type: :controller do
  describe 'post a text message request' do
    let(:valid_sms) { { to_number: '16177174802', body: 'hi' } }
    let(:invalid_sms) { { to_number: '6177174802', body: '' } }

    it 'only send json response' do
      post :create, params: { text_message: valid_sms }
      expect(response.content_type).to include('application/json')
    end

    it 'send json response even custom formats are provided' do
      post :create, params: { text_message: valid_sms, format: 'text/html' }
      expect(response.content_type).to include('application/json')
    end

    it 'send status code 201 created when successfully processed' do
      post :create, params: { text_message: valid_sms }
      expect(response.status).to be(201)
    end

    it 'send status code 422 unprocessable_entity with error message when root key :text_message is not present' do
      post :create, params: valid_sms
      expect(response.status).to be_equal(422)
      expect(response.body).to include('param is missing')
    end

    it 'send status code 422 unprocessable_entity with error message when validation fails' do
      post :create, params: { text_message: invalid_sms }
      expect(response.status).to be_equal(422)
      expect(response.body).to include('Validation failed')
    end

  end
end