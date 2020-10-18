class AddSmsProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :sms_providers do |t|
      t.text :url
      t.string :redis_key_prefix
      t.timestamps
    end
  end
end
