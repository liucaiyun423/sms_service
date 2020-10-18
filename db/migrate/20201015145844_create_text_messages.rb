class CreateTextMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :text_messages do |t|
      t.string :to_number
      t.string :message
      t.string :message_id
      t.integer :status
      t.integer :lock_version
      t.timestamps
    end
    add_index :text_messages, :message_id
    add_index :text_messages, %i[id status], unique: true
  end
end
