require 'rails_helper'

RSpec.describe TextMessageLogsController, type: :controller do
  it 'create a logs for every request' do
    post :create, params: { status: 'delivered', message_id: 'abcedf' }
    expect(response.status).to be_equal(204)
  end
end
