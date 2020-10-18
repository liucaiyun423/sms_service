class TestController < ApplicationController

  def create
    # sleep(1)
    # render status: 500, json: { "message_id": "abcdefg"}
    render status: 500, json: { "message_id": "abcdefg"}
  end
end