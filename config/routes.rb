Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope '/api', defaults: { format: 'json' } do
    resources :text_messages, only: %w[create]
    resources :text_message_logs, only: [:create]
  end

  post '/delivery_status', to: 'text_message_logs#create', defaults: { format: 'json' }
  post '/test/:id', to: 'test#create'
end
