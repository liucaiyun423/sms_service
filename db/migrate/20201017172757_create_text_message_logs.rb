class CreateTextMessageLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :text_message_logs do |t|
      t.string :message_id
      t.string :status
      t.timestamps
    end
  end
end
