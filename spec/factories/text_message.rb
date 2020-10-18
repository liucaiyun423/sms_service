FactoryBot.define do
  factory :text_message do
    to_number { '16177174802' }
    message { 'hello,there !' }
  end
end